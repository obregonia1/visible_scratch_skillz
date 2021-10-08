<template>
  <div>
    <input type="hidden" name="chart[chart_code]" id="chart_code" :value="JSON.stringify(chartCodes)">
    <input type="hidden" name="chart[image]" id="chart_image" :value="imageUrl">
  </div>
  <div v-if="editing" class="vss-chart-title">
    <label for="chart_title" class="label">Title</label>
    <input type="text" name="chart[title]" id="chart_title" v-model="title" class="input is-small" required maxlength="50">
  </div>
  <div v-else="!editing" class="vss-chart-title vss-is-show is-flex is-justify-content-flex-end is-align-items-flex-end">
    <h2 class="has-text-weight-bold is-size-4">{{ title }}</h2>
    <div class='vss-chart-edit' v-if="!editing && (userId === currentUserId)" >
      <a @click="edit" class="button edit is-small has-text-weight-bold">Edit</a>
      <a data-confirm="Are you sure?" class="is-size-7" rel="nofollow" data-method="delete" :href="`/charts/${chartId}`">Delete</a>
    </div>
  </div>
  <div class="vss-chart-wrapper">
    <div id="chart"></div>
  </div>
  <template v-if="editing">
    <div class="vss-select-container">
      <div class="vss-select-block">
        <p class="label">Trick</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input type="radio" value="baby" v-model="trick" checked="checked">
            <span>Baby</span>
          </label>
          <label class="radio">
            <input type="radio" value="chirp" v-model="trick">
            <span>Chirp</span>
          </label>
          <label class="radio">
            <input type="radio" value="slice" v-model="trick">
            <span>Slice</span>
          </label>
          <label class="radio">
            <input type="radio" value="chop" v-model="trick">
            <span>Chop</span>
          </label>
          <label class="radio">
            <input type="radio" value="transformer" v-model="trick">
            <span>Transformer</span>
          </label>
          <label class="radio">
            <input type="radio" value="flare" v-model="trick">
            <span>Flare</span>
          </label>
        </div>
      </div>

      <div class="vss-select-block">
        <p class="label">Click Count</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input type="radio" value="1" v-model="clickCount" checked="checked" :disabled="trick !== 'flare'">
            <span>1</span>
          </label>
          <label class="radio">
            <input type="radio" value="2" v-model="clickCount" :disabled="trick !== 'transformer' && trick !== 'flare'">
            <span>2</span>
          </label>
          <label class="radio">
            <input type="radio" value="3" v-model="clickCount" :disabled="trick !== 'transformer' && trick !== 'flare'">
            <span>3</span>
          </label>
          <label class="radio">
            <input type="radio" value="4" v-model="clickCount" :disabled="trick !== 'transformer'">
            <span>4</span>
          </label>
        </div>
      </div>

      <div class="vss-select-block">
        <p class="label">Pattern</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input type="radio" value="forward" v-model="pattern" checked="checked">
            <span>Forward</span>
          </label>
          <label class="radio">
            <input type="radio" value="backward" v-model="pattern">
            <span>Backward</span>
          </label>
          <label class="radio">
            <input type="radio" value="orbit" v-model="pattern">
            <span>Orbit</span>
          </label>
        </div>
      </div>

      <div class="vss-select-block">
        <p class="label">Beat Length</p>
        <div class="vss-select-block__inner">
          <label class="radio">
            <input type="radio" value="6" v-model="beatLength" checked="checked">
            <span>1</span>
          </label>
          <label class="radio">
            <input type="radio" value="3" v-model="beatLength">
            <span>1/2</span>
          </label>
          <label class="radio">
            <input type="radio" value="2" v-model="beatLength">
            <span>1/3</span>
          </label>
          <label class="radio">
            <input type="radio" value="1.5" v-model="beatLength">
            <span>1/4</span>
          </label>
          <label class="radio">
            <input type="radio" value="1" v-model="beatLength">
            <span>1/6</span>
          </label>
          <label class="radio">
            <input type="radio" value="0.75" v-model="beatLength">
            <span>1/8</span>
          </label>
        </div>
      </div>
    </div>

    <div class="vss-button-container">
      <div class="vss-button-row is-flex-wrap-wrap is-align-items-center is-mobile">
        <div class="vss-button-column"><a @click='addTrick' class="button vss-bordered-button">Add Trick</a></div>
        <div class="vss-button-column"><a @click='addRest' class="button vss-bordered-button">Add Rest</a></div>
        <div class="vss-button-column"><a @click='allClear' class="button vss-bordered-button">All Clear</a></div>
        <div class="vss-button-column"><a @click='delete' class="button vss-bordered-button">Delete</a></div>
      </div>
    </div>

    <div class="vss-button-container">
      <div class="vss-button-row submit is-mobile">
        <div class="vss-button-column"><label for="vss-img" @click="exportImg" class="button vss-export has-text-weight-bold">Export <fa icon="image" /></label></div>
        <div v-if="!nonLogin" class="vss-button-column"><a @click="save" class="button vss-save has-text-weight-bold" data-disable-with="Saving">Save</a></div>
      </div>
    </div>
    <p v-if="nonLogin" class="has-text-centered"><a href="/users/sign_in" class="has-text-weight-bold">Login</a> to save chart you made.</p>
  </template>
  <div v-show="displayImg" class="vss-img-wrapper">
    <input type="checkbox" id="vss-img">
    <div class="vss-img-wrapper__inner">
      <img id="img">
      <div class="vss-img-wrapper__action">
        <a id="downloadImg" download="vss.png" class="button vss-download has-text-weight-bold">Download</a>
      </div>
      <label class="vss-img-wrapper__close" for="vss-img"><span></span></label>
    </div>
    <label class="vss-img-wrapper__overlay" for="vss-img"></label>
  </div>
</template>

<script>
import Konva from "konva";

export default {
  props: {
    chartId: { type: Number, required: true },
    currentUserId: { type: Number, required: true },
    nonLogin: { type: String, required: true }
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
    }
  },
  mounted() {
    if (this.chartId) {
      fetch(`/api/charts/${this.chartId}.json`, {
        method: 'GET',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin'
      })
          .then((response) => {
            return response.json()
          })
          .then((json) => {
            this.userId = json.user_id
            this.title = json.title
            this.chartCodes = JSON.parse(json.chart_code)
            this.renderChartCodes(this.chartCodes)
            const lastCode = this.chartCodes[this.chartCodes.length - 1]
            this.currentBeat = lastCode.beatPosition + lastCode.beatLength
            this.loaded = true
          })
          .catch((error) => {
            console.warn('Failed to parsing', error)
          })
    } else {
      this.editing = true
    }

    this.stage = new Konva.Stage({
      container: 'chart',
      width: this.stageWidth,
      height: this.stageHeight
    })
    this.bgLineLayer = new Konva.Layer({
      name: 'bgLine'
    })

    this.addBgLines(this.totalBeatCount)

    this.bgLineLayer.offsetX(-10)
    this.bgLineLayer.offsetY(-5)
    this.codeLayer = new Konva.Layer({
      name: 'code'
    })

    this.codeLayer.offsetX(-10)
    this.codeLayer.offsetY(-5)
    this.stage.add(this.bgLineLayer)
    this.stage.draw()
  },
  methods: {
    renderChartCodes(chartCodes) {
      chartCodes.forEach((code) => {
        this.addCodeLine(code)
      })
      this.stage.draw()
    },
    addCodeLine(code) {
      let y1 = null
      let y2 = null
      let strokeWidth = null
      let stroke = null
      let layer = this.codeLayer
      const chartHeight = this.chartHeight()
      if (code.trick !== 'rest') {
        y1 = code.pattern === 'forward' ? chartHeight : 0
        y2 = code.pattern === 'forward' ? 0 : chartHeight
        strokeWidth = 2
        stroke = '#5a5454'
        name = 'code'
        if (code.trick !== 'baby') {
          this.drawFaderLine(code, layer)
        }
      } else if (code.trick === 'rest' && this.editing === true) {
        y1 = chartHeight
        y2 = chartHeight
        strokeWidth = 1
        stroke = 'red'
        name = 'rest'
      }
      const line = new Konva.Line({
        points: [
          this.toPixel(code.beatPosition),
          y1,
          this.toPixel(code.beatPosition) + this.toPixel(code.beatLength),
          y2
        ],
        stroke: stroke,
        strokeWidth: strokeWidth,
        name: name,
      })
      layer.add(line)
      this.stage.add(layer)
      this.stage.draw()
    },
    drawFaderLine(code, layer) {
      code.faderPositions.forEach(faderPosition => {
        const faderLine = new Konva.Line({
          points: this.faderPoints(code, faderPosition),
          stroke: '#5a5454',
          strokeWidth: 1,
          name: 'fader',
        })
        layer.add(faderLine)
      })
    },
    chartHeight() {
      return this.stageHeight - 10
    },
    chartWidth() {
      return this.stageWidth - 20
    },
    toPixel(beatPosition) {
      const oneBeatWidth = this.chartWidth() / 4
      return beatPosition * oneBeatWidth / 6
    },
    faderPoints(code, faderPosition) {
      const faderPositionPx = this.toPixel(code.beatPosition) + this.toPixel(faderPosition)
      const x1 = faderPositionPx - 7
      const x2 = faderPositionPx + 7
      const chartHeight = this.chartHeight()
      if (code.pattern === 'forward') {
        const y = chartHeight - faderPosition / code.beatLength * chartHeight
        return [x1, y, x2, y]
      } else if (code.pattern === 'backward') {
        const y = faderPosition / code.beatLength * chartHeight
        return [x1, y, x2, y]
      }
    },
    drawAddTrick(pattern) {
      const code = {
        trick: this.trick,
        pattern: pattern,
        beatLength: Number(this.beatLength),
        beatPosition: this.currentBeat,
        faderPositions: this.calcFaderPositions(pattern),
      }
      this.chartCodes.push(code)
      this.currentBeat += Number(this.beatLength)
      this.addCodeLine(code)
    },
    calcFaderPositions(pattern) {
      if (this.trick === 'chirp') {
        return [pattern === 'forward' ? Number(this.beatLength) : 0]
      } else if (this.trick === 'slice') {
        return [pattern === 'forward' ? 0 : Number(this.beatLength)]
      } else if (this.trick === 'chop') {
        return [0, Number(this.beatLength)]
      } else if (this.trick === 'transformer') {
        let faderPositions = [0]
        for (let n = 1; n <= Number(this.clickCount); n++) {
          faderPositions.push(Number(this.beatLength) * n / Number(this.clickCount))
        }
        return faderPositions
      } else if (this.trick === 'flare') {
        let faderPositions = []
        for (let n = 1; n <= Number(this.clickCount); n++) {
          faderPositions.push(Number(this.beatLength) * n / (Number(this.clickCount) + 1))
        }
        return faderPositions
      }
    },
    addTrick() {
      if (this.currentBeat < 24) {
        if (this.pattern === 'orbit') {
          this.drawAddTrick('forward')
          this.drawAddTrick('backward')
        } else {
          this.drawAddTrick(this.pattern)
        }
      }
    },
    addRest() {
      const code = {
        trick: 'rest',
        pattern: null,
        beatLength: this.beatLength,
        beatPosition: this.currentBeat
      }
      this.chartCodes.push(code)
      this.currentBeat += Number(this.beatLength)
      this.addCodeLine(code)
    },
    allClear() {
      this.chartCodes.splice(0)
      this.codeLayer.destroy()
      this.currentBeat = 0
    },
    delete() {
      if (this.chartCodes.length > 0) {
        const lastCode = this.chartCodes.pop()
        this.codeLayer.destroy()
        this.renderChartCodes(this.chartCodes)
        this.stage.draw()
        this.currentBeat -= lastCode.beatLength
      }
    },
    addBgLines(beatCount) {
      // 1小節のchartWidthを4分割して1拍の幅にする
      const solidLineWidth = this.chartWidth() / 4
      for (let i = 0; i <= beatCount; i++) {
        this.addBgSolidLine(i * solidLineWidth)
      }
      // 1拍を6分割した基準線をつくる
      const dashedLineWidth = solidLineWidth / 6
      for (let i = 1; i <= beatCount * 6; i++) {
        if (i % 6 !== 0) {
          this.addBgDashedLine(i * dashedLineWidth)
        }
      }
    },
    addBgSolidLine(x) {
      this.addBgLine(x, '#c0c0c0')
    },
    addBgDashedLine(x) {
      this.addBgLine(x, '#d3d3d3', true)
    },
    addBgLine(x, stroke, dash = null) {
      this.bgLine = new Konva.Line({
        points: [x, this.chartHeight(), x, 0],
        stroke: stroke,
        strokeWidth: 1,
        dash: dash ? [3, 3] : null
      })
      this.bgLineLayer.add(this.bgLine)
    },
    convert() {
      this.imageStage = new Konva.Stage({
        container: 'img',
        width: this.stageWidth,
        height: this.stageHeight + 50,
      })
      const bgColor = new Konva.Rect({
        width: this.stageWidth,
        height: this.stageHeight + 50,
        fill: 'white'
      })

      const bgColorLayer = new Konva.Layer({
        name: 'bgColor'
      })
      bgColorLayer.add(bgColor)
      this.imageStage.add(bgColorLayer)
      const bgLineLayer = this.bgLineLayer.clone()
      this.imageStage.add(bgLineLayer)

      const codeLayer = this.codeLayer.clone()
      const restLines = codeLayer.getChildren(line => {
        return line.attrs.name === 'rest'
      })
      restLines.map(line => {
        line.setAttr('visible', false)
      })
      this.imageStage.add(codeLayer)

      bgLineLayer.offsetY(-30)
      codeLayer.offsetY(-30)

      const textLayer = new Konva.Layer({
        name: 'text'
      })
      const title = new Konva.Text({
        x: this.imageStage.width() / 2,
        y: 10,
        text: this.title,
        fill: 'black',
        fontSize: 16,
      })
      title.offsetX(title.width() / 2)
      textLayer.add(title)

      const appName = new Konva.Text({
        x: this.imageStage.width() / 2,
        y: 140,
        text: '©︎Visible Scratch Skillz',
        fill: 'black',
        fontSize: 12,
      })
      appName.offsetX(appName.width() / 2)
      textLayer.add(appName)

      this.imageStage.add(textLayer)
      this.imageUrl = this.imageStage.toDataURL({
        pixelRatio: 2
      })
    },
    save() {
      const convert = this.convert
      const promise = new Promise(function(resolve) {
        convert()
        resolve()
      })
      function onFulfilled() {
        const form = document.getElementById('form')
        form.submit()
      }
      promise.then(onFulfilled)
    },
    exportImg() {
      this.convert()
      this.displayImg = true
      const img = document.getElementById("img")
      img.src = this.imageUrl
      const canvas = document.querySelector('.konvajs-content');
      window.scroll(0, canvas.clientWidth);
      const downloadImg = document.getElementById("downloadImg")
      downloadImg.href = this.imageUrl
    },
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    edit() {
      this.editing = true
      this.renderChartCodes(this.chartCodes)
    }
  }
}
</script>
