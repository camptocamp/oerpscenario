# -*- coding: utf-8 -*-
"""Enhancements for Behave.

Some of them might be proposed upstream
"""
import os.path

from behave import formatter
from behave import matchers
from behave import model
from behave import runner
from behave.formatter.ansi_escapes import up
from behave.model_describe import escape_cell, escape_triple_quotes, indent
# Defeat lazy import, because we need to patch the formatters
import behave.formatter.plain
import behave.formatter.pretty

__all__ = ['patch_all']
_behave_patched = False


def patch_all():
    global _behave_patched
    if not _behave_patched:
        patch_matchers_get_matcher()
        patch_model_Table_raw()
        formatter.formatters.register(PlainFormatter)
        formatter.formatters.register(PrettyFormatter)
        patch_runner_load_step_definitions()
        _behave_patched = True

def patch_runner_load_step_definitions():
    """
    Pass extra steps directories to Runner.load_step_definitions

    That method has an extra_step_paths kwarg defaulting to nothing, and the
    caller does not provide a value. We compute someting sensible from the
    command line paths. 
    """
    runner.Runner._load_step_definitions = runner.Runner.load_step_definitions
    def load_step_definitions(self):
        extra_step_paths = []
        for path in self.config.paths[1:]:
            path = os.path.abspath(path)
            path = os.path.join(path, 'steps')
            if os.path.isdir(path):
                extra_step_paths.append(path)
        self._load_step_definitions(extra_step_paths)
    runner.Runner.load_step_definitions = load_step_definitions

def patch_matchers_get_matcher():
    # Detect the regex expressions
    # https://github.com/behave/behave/issues/73
    def get_matcher(func, string):
        if string[:1] == string[-1:] == '/':
            return matchers.RegexMatcher(func, string[1:-1])
        return matchers.current_matcher(func, string)
    matchers.get_matcher = get_matcher


def patch_model_Table_raw():
    # Add attribute Table.raw
    def raw(self):
        yield list(self.headings)
        for row in self.rows:
            yield list(row)
    model.Table.raw = property(raw)


# Flush the output after each scenario
class PlainFormatter(formatter.plain.PlainFormatter):

    def result(self, result):
        super(PlainFormatter, self).result(result)
        self.stream.flush()

    def eof(self):
        if self.config.show_skipped:
            self.stream.write('\n')


# https://github.com/behave/behave/pull/157
# https://github.com/behave/behave/pull/165
# https://github.com/behave/behave/issues/118
#
# Fixes:
# * colors for tags
# * colors for tables
# * colors for docstrings
class PrettyFormatter(formatter.pretty.PrettyFormatter):

    def result(self, result):
        if not self.monochrome:
            lines = self.step_lines + 1
            if self.show_multiline:
                if result.table:
                    lines += self.table_lines
                if result.text:
                    lines += self.text_lines
            self.stream.write(up(lines))
            arguments = []
            location = None
            if self._match:
                arguments = self._match.arguments
                location = self._match.location
            self.print_step(result.status, arguments, location, True)
        if result.error_message:
            self.stream.write(indent(result.error_message.strip(), u'      '))
            self.stream.write('\n\n')
        self.stream.flush()

    def table(self, table, strformat=unicode):
        cell_lengths = []
        all_rows = [table.headings] + table.rows
        for row in all_rows:
            lengths = [len(escape_cell(c)) for c in row]
            cell_lengths.append(lengths)

        max_lengths = []
        for col in range(0, len(cell_lengths[0])):
            max_lengths.append(max([c[col] for c in cell_lengths]))

        for i, row in enumerate(all_rows):
            #for comment in row.comments:
            #    self.stream.write('      %s\n' % comment.value)
            self.stream.write('      |')
            for j, (cell, max_length) in enumerate(zip(row, max_lengths)):
                self.stream.write(' ')
                self.stream.write(strformat(cell))
                self.stream.write(' ' * (max_length - cell_lengths[i][j]))
                self.stream.write(' |')
            self.stream.write('\n')
        self.stream.flush()

        table_width = 7 + 3 * len(table.headings) + sum(max_lengths)
        self.table_lines = len(all_rows) * (1 + table_width // self.display_width)

    def doc_string(self, doc_string, strformat=unicode):
        triplequotes = self.format('comments').text(u'"""')
        self.text_lines = 2 + sum(
            [(1 + (6 + len(line)) // self.display_width)
             for line in doc_string.splitlines()])
        doc_string = strformat(escape_triple_quotes(doc_string))
        self.stream.write(indent(u'\n'.join([
            triplequotes, doc_string, triplequotes]), u'      ') + u'\n')

    def print_step(self, status, arguments, location, proceed):
        if proceed:
            step = self.steps.pop(0)
        else:
            step = self.steps[0]

        text_format = self.format(status)
        arg_format = self.arg_format(status)

        self.stream.write('    ')
        self.stream.write(text_format.text(step.keyword + ' '))
        line_length = 5 + len(step.keyword)

        step_name = unicode(step.name)

        text_start = 0
        for arg in arguments:
            if arg.end <= text_start:
                # -- SKIP-OVER: Optional and nested regexp args
                #    - Optional regexp args (unmatched: None).
                #    - Nested regexp args that are already processed.
                continue
                # -- VALID, MATCHED ARGUMENT:
            assert arg.original is not None
            text = step_name[text_start:arg.start]
            self.stream.write(text_format.text(text))
            line_length += len(text)
            self.stream.write(arg_format.text(arg.original))
            line_length += len(arg.original)
            text_start = arg.end

        if text_start != len(step_name):
            text = step_name[text_start:]
            self.stream.write(text_format.text(text))
            line_length += (len(text))

        if self.show_timings:
            if status in ('passed', 'failed'):
                timing = '%6.3fs' % step.duration
            else:
                timing = ' ' * 7
        else:
            timing = ''
        if self.show_source:
            location = unicode(location)
            if timing:
                location = location + ' ' + timing
            location = self.indented_text(location, proceed)
            self.stream.write(self.format('comments').text(location))
            line_length += len(location)
        elif timing:
            timing = self.indented_text(timing, proceed)
            self.stream.write(self.format('comments').text(timing))
            line_length += len(timing)
        self.stream.write("\n")

        self.step_lines = int((line_length - 1) // self.display_width)

        if self.show_multiline:
            if step.text:
                self.doc_string(step.text, strformat=text_format.text)
            if step.table:
                self.table(step.table, strformat=text_format.text)

    def print_tags(self, tags, indentation):
        if not tags:
            return
        tags = u' '.join(u'@' + tag for tag in tags)
        self.stream.write(indentation + self.format('tag').text(tags) + '\n')

    def eof(self):
        self.replay()
        if self.config.show_skipped:
            self.stream.write('\n')
        self.stream.flush()
