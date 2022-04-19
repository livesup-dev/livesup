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
        width: spec["width"] || 400,
        height: spec["height"] || 200,
        margin: {
          t: 0,
          b: 0
        },
        paper_bgcolor: "rgba(0,0,0,0)",
        plot_bgcolor: "rgba(0,0,0,0)"
      };

      var config = { responsive: true, displayModeBar: false };
      Plotly.newPlot(this.el, data, layout, config);
    });
  }
};

function getProps(hook) {
  return {
    id: getAttributeOrThrow(hook.el, "data-id"),
  };
}