odoo.define('specific_timesheet.sheet', function (require) {
    "use strict";

    var core = require('web.core');
    var WeeklyTimesheet = core.form_custom_registry.get('weekly_timesheet');

    var ReadonlyWeeklyTimesheet = WeeklyTimesheet.extend({
        /**
         * Override parent method to remove no-content help div in readonly mode.
         */
        display_data: function () {
            this._super();
            if (this.get('effective_readonly')) {
                this.$(".oe_timesheet_weekly .oe_view_nocontent").parent('div').empty();
            }
        }
    });
    core.form_custom_registry.add('weekly_timesheet', ReadonlyWeeklyTimesheet);
});
