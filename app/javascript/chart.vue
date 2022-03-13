<template>
  <div>
    <input
      id="chart_code"
      type="hidden"
      name="chart[chart_code]"
      :value="JSON.stringify(chartCodes)"
    />
    <input
      id="chart_image"
      type="hidden"
      name="chart[image]"
      :value="imageUrl"
    />
  </div>
  <div v-if="editing" class="vss-chart-title">
    <label for="chart_title" class="label">Title</label>
    <input
      id="chart_title"
      v-model="title"
      type="text"
      name="chart[title]"
      class="input is-small"
      required
      maxlength="50"
    />
  </div>
  <div
    v-else
    class="vss-chart-title vss-is-show is-flex is-justify-content-flex-end is-align-items-flex-end"
  >
    <h2 class="has-text-weight-bold is-size-4">{{ title }}</h2>
    <div v-if="!editing && userId === currentUserId" class="vss-chart-edit">
      <a class="button edit is-small has-text-weight-bold" @click="edit"
        >Edit</a
      >
      <a
        data-confirm="Are you sure?"
        class="is-size-7"
        rel="nofollow"
        data-method="delete"
        :href="`/charts/${chartId}`"
        >Delete</a
      >
    </div>
  </div>
  <chart-body
      :chart-id="chartId"
      :current-user-id="currentUserId"
      :non-login="nonLogin"
      @editing="edit1"
      @setTitle="setTitle"
      @setChartCodes="setChartCodes"
      @setLayer="setLayer"
      ref="chart-body"
      :trick="trick"
      @setUserId="setUserId"
      @setBgLineLayer="setBgLineLayer"
      @setCodeLayer="setCodeLayer"
      :chart-data="chartCodes"
      :current-bee="currentBeat"
      :edit="editing"
  >
  </chart-body>
  <template v-if="editing">
    <div class="vss-select-container">
      <div class="vss-select-block">
        <p class="label">Trick</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input
              v-model="trick"
              type="radio"
              value="baby"
              checked="checked"
            />
            <span>Baby</span>
          </label>
          <label class="radio">
            <input v-model="trick" type="radio" value="chirp" />
            <span>Chirp</span>
          </label>
          <label class="radio">
            <input v-model="trick" type="radio" value="slice" />
            <span>Slice</span>
          </label>
          <label class="radio">
            <input v-model="trick" type="radio" value="chop" />
            <span>Chop</span>
          </label>
          <label class="radio">
            <input v-model="trick" type="radio" value="transformer" />
            <span>Transformer</span>
          </label>
          <label class="radio">
            <input v-model="trick" type="radio" value="flare" />
            <span>Flare</span>
          </label>
        </div>
      </div>

      <div class="vss-select-block">
        <p class="label">Click Count</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input
              v-model="clickCount"
              type="radio"
              value="1"
              checked="checked"
              :disabled="trick !== 'flare'"
            />
            <span>1</span>
          </label>
          <label class="radio">
            <input
              v-model="clickCount"
              type="radio"
              value="2"
              :disabled="trick !== 'transformer' && trick !== 'flare'"
            />
            <span>2</span>
          </label>
          <label class="radio">
            <input
              v-model="clickCount"
              type="radio"
              value="3"
              :disabled="trick !== 'transformer' && trick !== 'flare'"
            />
            <span>3</span>
          </label>
          <label class="radio">
            <input
              v-model="clickCount"
              type="radio"
              value="4"
              :disabled="trick !== 'transformer'"
            />
            <span>4</span>
          </label>
        </div>
      </div>

      <div class="vss-select-block">
        <p class="label">Pattern</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input
              v-model="pattern"
              type="radio"
              value="forward"
              checked="checked"
            />
            <span>Forward</span>
          </label>
          <label class="radio">
            <input v-model="pattern" type="radio" value="backward" />
            <span>Backward</span>
          </label>
          <label class="radio">
            <input v-model="pattern" type="radio" value="orbit" />
            <span>Orbit</span>
          </label>
        </div>
      </div>

      <div class="vss-select-block">
        <p class="label">Beat Length</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input
              v-model="beatLength"
              type="radio"
              value="6"
              checked="checked"
            />
            <span>1</span>
          </label>
          <label class="radio">
            <input v-model="beatLength" type="radio" value="3" />
            <span>1/2</span>
          </label>
          <label class="radio">
            <input v-model="beatLength" type="radio" value="2" />
            <span>1/3</span>
          </label>
          <label class="radio">
            <input v-model="beatLength" type="radio" value="1.5" />
            <span>1/4</span>
          </label>
          <label class="radio">
            <input v-model="beatLength" type="radio" value="1" />
            <span>1/6</span>
          </label>
          <label class="radio">
            <input v-model="beatLength" type="radio" value="0.75" />
            <span>1/8</span>
          </label>
        </div>
      </div>

      <div class="vss-select-block">
        <p class="label">Public</p>
        <label class="checkbox">
          <input v-model="isPublic" type="checkbox" />
          Is Public
        </label>
      </div>
    </div>

    <div class="vss-button-container">
      <div
        class="vss-button-row is-flex-wrap-wrap is-align-items-center is-mobile"
      >
        <div class="vss-button-column">
          <a class="button vss-bordered-button" @click="addTrick">Add Trick</a>
        </div>
        <div class="vss-button-column">
          <a class="button vss-bordered-button" @click="addRest">Add Rest</a>
        </div>
        <div class="vss-button-column">
          <a class="button vss-bordered-button" @click="allClear">All Clear</a>
        </div>
        <div class="vss-button-column">
          <a class="button vss-bordered-button" @click="destroy">Delete</a>
        </div>
      </div>
    </div>

    <div class="vss-button-container">
      <div class="vss-button-row submit is-mobile">
        <div class="vss-button-column">
          <label
            for="vss-img"
            class="button vss-export has-text-weight-bold"
            @click="exportImg"
            >Export <font-awesome-icon icon="image"
          /></label>
        </div>
        <div v-if="!nonLogin" class="vss-button-column">
          <a
            class="button vss-save has-text-weight-bold"
            data-disable-with="Saving"
            @click="save"
            >Save</a
          >
        </div>
      </div>
    </div>
    <p v-if="nonLogin" class="has-text-centered">
      <a href="/users/sign_in" class="has-text-weight-bold">Login</a> to save
      chart you made.
    </p>
  </template>
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
import ChartBody from "./chartBody";

export default {
  components: {
    ChartBody
  },
  props: {
    chartId: { type: Number, required: true },
    currentUserId: { type: Number, required: true },
    nonLogin: { type: String, required: true },
    editing: { type: Boolean, require: true },
    title: { type: String },
    codeLayer: { type: Object },
    pattern: { type: String, require: true },
    trick: { type: String, require: true },
    beatLength: { type: Number, require: true },
    currentBeat: { type: Number, require: true },
    faderPositions: { type: Array },
    clickCount: { type: Number },
    userId: { type: Number },
    bgLineLayer: { type: Object },
    test: { type: String },
  },
  data() {
    return {
      chartCodes: [],
      trick: 'baby',
      pattern: 'forward',
      beatLength: 6,
      stage: {},
      currentBeat: 0,
      codeLayer: null,
      faderPositions: null,
      clickCount: 1,
      displayImg: false,
      title: '',
      imageUrl: '',
      loaded: null,
      editing: false,
      userId: '',
      imageStage: null,
      stageWidth: 500,
      stageHeight: 110,
      totalBeatCount: 4,
      bgLineLayer: {},
    };
  },
  mounted() {
    if (this.chartId) {
      fetch(`/api/charts/${this.chartId}.json`, {
        method: 'GET',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token(),
        },
        credentials: 'same-origin',
      })
          .then((response) => {
            return response.json();
          })
          .then((json) => {
            this.userId = json.user_id;
            this.$emit('setUserId', this.userId)
            this.title = json.title;
            this.$emit('setTitle', this.title)
            this.isPublic = json.is_public || false;
            this.chartCodes = JSON.parse(json.chart_code);
            this.$emit('setChartCodes', this.chartCodes)
            this.$emit('renderChartCodes', this.chartCodes);
            const lastCode = this.chartCodes[this.chartCodes.length - 1];
            this.currentBeat = lastCode.beatPosition + lastCode.beatLength;
            this.loaded = true;
          })
          .catch((error) => {
            console.warn('Failed to parsing', error);
          });
    } else {
      this.editing = true;
      this.$emit('editing');
    }
  },
  methods: {
    renderChartCodes(chartCodes) {
      chartCodes.forEach((code) => {
        this.addCodeLine(code);
      });
      this.stage.draw();
    },
    addCodeLine(code) {
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
        if (code.trick !== 'baby') {
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
      this.stage.add(layer);
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
    drawAddTrick(pattern) {
      const code = {
        trick: this.trick,
        pattern: pattern,
        beatLength: Number(this.beatLength),
        beatPosition: this.currentBeat,
        faderPositions: this.calcFaderPositions(pattern),
      };
      this.chartCodes.push(code);
      this.currentBeat += Number(this.beatLength);
      this.$refs["chart-body"].addCodeLine(code);
    },
    calcFaderPositions(pattern) {
      if (this.trick === 'chirp') {
        return [pattern === 'forward' ? Number(this.beatLength) : 0];
      } else if (this.trick === 'slice') {
        return [pattern === 'forward' ? 0 : Number(this.beatLength)];
      } else if (this.trick === 'chop') {
        return [0, Number(this.beatLength)];
      } else if (this.trick === 'transformer') {
        let faderPositions = [0];
        for (let n = 1; n <= Number(this.clickCount); n++) {
          faderPositions.push(
            (Number(this.beatLength) * n) / Number(this.clickCount)
          );
        }
        return faderPositions;
      } else if (this.trick === 'flare') {
        let faderPositions = [];
        for (let n = 1; n <= Number(this.clickCount); n++) {
          faderPositions.push(
            (Number(this.beatLength) * n) / (Number(this.clickCount) + 1)
          );
        }
        return faderPositions;
      }
    },
    addTrick() {
      if (this.currentBeat < 24) {
        if (this.pattern === 'orbit') {
          this.drawAddTrick('forward');
          this.drawAddTrick('backward');
        } else {
          this.drawAddTrick(this.pattern);
        }
      }
    },
    addRest() {
      const code = {
        trick: 'rest',
        pattern: null,
        beatLength: this.beatLength,
        beatPosition: this.currentBeat,
      };
      this.chartCodes.push(code);
      this.currentBeat += Number(this.beatLength);
      this.$refs["chart-body"].addCodeLine(code);
      // this.addCodeLine(code);
    },
    allClear() {
      // this.$refs["chart-body"].allClear()
      this.chartCodes.splice(0);
      this.codeLayer.destroy();
      this.currentBeat = 0;
    },
    destroy() {
      if (this.chartCodes.length > 0) {
        const lastCode = this.chartCodes.pop();
        this.currentBeat -= lastCode.beatLength;
        this.codeLayer.destroy();
      }
      this.$refs["chart-body"].renderChartCodes(this.chartCodes)
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
      this.$refs["chart-body"].save()
    },
    exportImg() {
      this.convert();
      this.displayImg = true;
      const img = document.getElementById('img');
      img.src = this.imageUrl;
      const downloadImg = document.getElementById('downloadImg');
      downloadImg.href = this.imageUrl;
    },
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]');
      return meta ? meta.getAttribute('content') : '';
    },
    edit() {
      this.editing = true;
      this.$refs["chart-body"].edit()
    },
    edit1() {
      this.editing = true;
    },
    setTitle(title) {
      this.title = title;
    },
    setChartCodes(chartCodes) {
      this.chartCodes = chartCodes;
    },
    draw(renderChartCodes) {
      renderChartCodes(this.chartCodes);
    },
    setLayer(layer) {
      this.codeLayer = layer
    },
    setUserId(userId) {
      this.userId = userId
    },
    setBgLineLayer(bgLineLayer) {
      this.bgLineLayer = bgLineLayer
    },
    setCodeLayer(codeLayer) {
      this.codeLayer = codeLayer
    }
  },
};
</script>
