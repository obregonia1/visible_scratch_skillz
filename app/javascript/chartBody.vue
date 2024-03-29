<template>
  <div class="vss-chart-wrapper">
    <div id="chart"></div>
  </div>
  <div v-show="displayImg" class="vss-img-wrapper">
    <input id="vss-img" type="checkbox" />
    <div class="vss-img-wrapper__inner">
      <img id="img" />
      <div class="vss-img-wrapper__action">
        <a
          id="downloadImg"
          :download="title"
          class="button vss-download has-text-weight-bold"
          >Download</a
        >
      </div>
      <label class="vss-img-wrapper__close" for="vss-img"><span></span></label>
    </div>
    <label class="vss-img-wrapper__overlay" for="vss-img"></label>
  </div>
</template>

<script>
import Konva from 'konva';

export default {
  name: 'chart-body',
  props: {
    title: { type: String, required: true },
    editing: { type: Boolean, require: true },
    totalBeatCount: { type: Number },
  },
  data() {
    return {
      stage: {},
      codeLayer: null,
      displayImg: false,
      imageUrl: '',
      loaded: null,
      imageStage: null,
      stageWidth: 500,
      stageHeight: 110,
      bgLineLayer: {},
    };
  },
  mounted() {
    this.stage = new Konva.Stage({
      container: 'chart',
      width: this.stageWidth,
      height: this.stageHeight,
    });
    this.bgLineLayer = new Konva.Layer({
      name: 'bgLine',
    });

    this.addBgLines(this.totalBeatCount);

    this.bgLineLayer.offsetX(-10);
    this.bgLineLayer.offsetY(-5);

    this.codeLayer = new Konva.Layer({
      name: 'code',
    });

    this.codeLayer.offsetX(-10);
    this.codeLayer.offsetY(-5);
    this.stage.add(this.bgLineLayer);
    this.stage.draw();
  },
  methods: {
    renderChartCodes(chartCodes) {
      chartCodes.forEach((code) => {
        this.addCodeLineLayer(code);
      });
      this.stage.draw();
    },
    addLayer(layer) {
      this.stage.add(layer);
    },
    addCodeLineLayer(code) {
      let y1 = null;
      let y2 = null;
      let strokeWidth = null;
      let stroke = null;
      let layer = this.codeLayer;
      const chartHeight = this.chartHeight();
      if (code.trick !== 'rest') {
        y1 = code.pattern === 'forward' ? chartHeight : 0;
        y2 = code.pattern === 'forward' ? 0 : chartHeight;
        strokeWidth = 2;
        stroke = '#5a5454';
        name = 'code';
        if (code.trick !== 'baby' && code.trick !== 'rest') {
          this.drawFaderLine(code, layer);
        }
      } else if (code.trick === 'rest' && this.editing === true) {
        y1 = chartHeight;
        y2 = chartHeight;
        strokeWidth = 1;
        stroke = 'red';
        name = 'rest';
      }
      const line = new Konva.Line({
        points: [
          this.toPixel(code.beatPosition),
          y1,
          this.toPixel(code.beatPosition) + this.toPixel(code.beatLength),
          y2,
        ],
        stroke: stroke,
        strokeWidth: strokeWidth,
        name: name,
      });
      layer.add(line);
      this.addLayer(layer);
      this.draw();
    },
    draw() {
      this.stage.draw();
    },
    drawFaderLine(code, layer) {
      code.faderPositions.forEach((faderPosition) => {
        const faderLine = new Konva.Line({
          points: this.faderPoints(code, faderPosition),
          stroke: '#5a5454',
          strokeWidth: 1,
          name: 'fader',
        });
        layer.add(faderLine);
      });
    },
    chartHeight() {
      return this.stageHeight - 10;
    },
    chartWidth() {
      return this.stageWidth - 20;
    },
    toPixel(beatPosition) {
      const oneBeatWidth = this.chartWidth() / 4;
      return (beatPosition * oneBeatWidth) / 6;
    },
    deleteCodeLayer() {
      this.codeLayer.destroy();
    },
    faderPoints(code, faderPosition) {
      const faderPositionPx =
        this.toPixel(code.beatPosition) + this.toPixel(faderPosition);
      const x1 = faderPositionPx - 7;
      const x2 = faderPositionPx + 7;
      const chartHeight = this.chartHeight();
      if (code.pattern === 'forward') {
        const y = chartHeight - (faderPosition / code.beatLength) * chartHeight;
        return [x1, y, x2, y];
      } else if (code.pattern === 'backward') {
        const y = (faderPosition / code.beatLength) * chartHeight;
        return [x1, y, x2, y];
      }
    },
    addBgLines(beatCount) {
      // 1小節のchartWidthを4分割して1拍の幅にする
      const solidLineWidth = this.chartWidth() / 4;
      for (let i = 0; i <= beatCount; i++) {
        this.addBgSolidLine(i * solidLineWidth);
      }
      // 1拍を6分割した基準線をつくる
      const dashedLineWidth = solidLineWidth / 6;
      for (let i = 1; i <= beatCount * 6; i++) {
        if (i % 6 !== 0) {
          this.addBgDashedLine(i * dashedLineWidth);
        }
      }
    },
    addBgSolidLine(x) {
      this.addBgLine(x, '#2c2c2c');
    },
    addBgDashedLine(x) {
      this.addBgLine(x, '#d3d3d3', true);
    },
    addBgLine(x, stroke, dash = null) {
      this.bgLine = new Konva.Line({
        points: [x, this.chartHeight(), x, 0],
        stroke: stroke,
        strokeWidth: 1,
        dash: dash ? [3, 3] : null,
      });
      this.bgLineLayer.add(this.bgLine);
    },
    convert() {
      this.imageStage = new Konva.Stage({
        container: 'img',
        width: this.stageWidth,
        height: this.stageHeight + 50,
      });
      const bgColor = new Konva.Rect({
        width: this.stageWidth,
        height: this.stageHeight + 50,
        fill: 'white',
      });

      const bgColorLayer = new Konva.Layer({
        name: 'bgColor',
      });
      bgColorLayer.add(bgColor);
      this.imageStage.add(bgColorLayer);
      const bgLineLayer = this.bgLineLayer.clone();
      this.imageStage.add(bgLineLayer);

      const codeLayer = this.codeLayer.clone();
      const restLines = codeLayer.getChildren((line) => {
        return line.attrs.name === 'rest';
      });
      restLines.map((line) => {
        line.setAttr('visible', false);
      });
      this.imageStage.add(codeLayer);

      bgLineLayer.offsetY(-30);
      codeLayer.offsetY(-30);

      const textLayer = new Konva.Layer({
        name: 'text',
      });
      const title = new Konva.Text({
        x: this.imageStage.width() / 2,
        y: 10,
        text: this.title,
        fill: 'black',
        fontSize: 16,
      });
      title.offsetX(title.width() / 2);
      textLayer.add(title);

      const appName = new Konva.Text({
        x: this.imageStage.width() / 2,
        y: 140,
        text: '©︎Visible Scratch Skillz',
        fill: 'black',
        fontSize: 12,
      });
      appName.offsetX(appName.width() / 2);
      textLayer.add(appName);

      this.imageStage.add(textLayer);
      this.imageUrl = this.imageStage.toDataURL({
        pixelRatio: 2,
      });
    },
    save() {
      const convert = this.convert;
      const promise = new Promise(function (resolve) {
        convert();
        resolve();
      });
      function onFulfilled() {
        const form = document.getElementById('form');
        form.submit();
      }
      promise.then(onFulfilled);
    },
    exportImg() {
      this.convert();
      this.displayImg = true;
      const img = document.getElementById('img');
      img.src = this.imageUrl;
      const downloadImg = document.getElementById('downloadImg');
      downloadImg.href = this.imageUrl;
    },
  },
};
</script>
