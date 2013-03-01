from support import model, assert_equal, puts, set_trace

@given(u'we assign to {users} the groups bellow')
def impl(ctx, users):
    puts(['This sentence is deprecated ! Please use "we assign to {users} the groups below" with one "l"'])
    raise Exception ("Sentence Deprecated !")
