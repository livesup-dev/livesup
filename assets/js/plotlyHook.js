import { getAttributeOrThrow } from "./lib/attribute";
import Plotly from 'plotly.js-dist';

export default {
  mounted() {
    let dragged;
    const hook = this;

    this.props = getProps(this);
    this.state = {
      container: null,
      viewPromise: null,
    };

    this.state.container = document.createElement("div");
    this.el.appendChild(this.state.container);

    this.handleEvent(`plotly:${this.props.id}:init`, ({ spec }) => {
      if (!spec.data) {
        spec.data = { values: [] };
      }

      var data = [spec];

      var layout = {
        font: {
          color: '#FFF'
        },
        width: 400,
        height: 200,
        margin: {
          t: 0,
          b: 0
        },
        paper_bgcolor: "rgba(0,0,0,0)",
        plot_bgcolor: "rgba(0,0,0,0)"
      };
      Plotly.newPlot(this.el, data, layout);
    });
  }
};

function getProps(hook) {
  return {
    id: getAttributeOrThrow(hook.el, "data-id"),
  };
}