import Sortable from 'sortablejs';

export default {
    mounted() {
        let dragged;
        const hook = this;

        const selector = '#' + this.el.id;

        // new Sortable(this.el, {
        //     animation: 150,
        //     sort: true,
        //     draggable: '.draggable',
        //     ghostClass: 'blue-background-class',
        //     dragClass: "shadow-xl"
        // });
        let el = document.getElementById("widget-list-draggable");
        if (el == null) {
            return;
        };
        new Sortable(el, {
            animation: 150,
            delay: 0,
            ghostClass: 'sortable-ghost',
            // Element dragging started
            onStart: function (/**Event*/evt) {
                console.log("on start!")
            },
            onEnd: function (evt) {
                hook.pushEventTo(selector, 'dropped', {
                    widget_id: evt.item.id,
                    old_index: evt.oldIndex,
                    new_index: evt.newIndex
                });
            },
        });
    },
};