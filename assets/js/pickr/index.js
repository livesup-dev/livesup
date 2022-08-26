import flatpickr from "flatpickr";

const Pickr = {
    mounted() {
        this.pickr = flatpickr(this.el, {
            wrap: true,
            altInput: this.el.dataset.pickrAltFormat ? true : false,
            altFormat: this.el.dataset.pickrAltFormat || "d M Y",
            dateFormat: this.el.dataset.pickrDateFormat || "Y-m-d"
        })
    },
    updated() {
        const altFormat = this.el.dataset.pickrAltFormat
        const wasFormat = this.pickr.config.altFormat
        if (altFormat !== wasFormat) {
            this.pickr.destroy()
            this.pickr = flatpickr(this.el, {
                wrap: true,
                altInput: this.el.dataset.pickrAltFormat ? true : false,
                altFormat: this.el.dataset.pickrAltFormat || "d M Y",
                dateFormat: this.el.dataset.pickrDateFormat || "Y-m-d"
            })
        }
    },
    destroyed() {
        this.pickr.destroy()
    }
}

export default Pickr