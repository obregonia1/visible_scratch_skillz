<template>
  <div>
    <input type="hidden" name="chart[chart_code]" id="chart_code" :value="JSON.stringify(chartCodes)">
    <input type="hidden" name="chart[image]" id="chart_image" :value="imageUrl">
  </div>
  <div v-if="editing" class="vss-chart-title">
    <label for="chart_title" class="label">Title</label>
    <input type="text" name="chart[title]" id="chart_title" v-model="title" class="input is-small">
  </div>
  <div v-else="!editing" class="vss-chart-title vss-is-show is-flex is-justify-content-flex-end">
    <h2 class="title is-size-4">{{ title }}</h2>
    <template v-if="!editing && (userId === currentUserId)" >
      <a @click="edit" class="button edit is-small has-text-weight-bold">Edit</a>
      <a data-confirm="Are you sure?" class="is-size-7 is-align-self-center" rel="nofollow" data-method="delete" :href="`/charts/${chartId}`">Delete</a>
    </template>
  </div>
  <div class="vss-chart-wrapper">
    <div id="chart"></div>
  </div>
  <template v-if="editing">
    <div class="vss-select-container">
      <div class="vss-select-block">
        <p class="label">Trick</p>
        <label class="radio">
          <input type="radio" value="baby" v-model="trick" checked="checked">
          Baby
        </label>
        <label class="radio">
          <input type="radio" value="chirp" v-model="trick">
          Chirp
        </label>
        <label class="radio">
          <input type="radio" value="slice" v-model="trick">
          Slice
        </label>
        <label class="radio">
          <input type="radio" value="chop" v-model="trick">
          Chop
        </label>
        <label class="radio">
          <input type="radio" value="transformer" v-model="trick">
          Transformer
        </label>
        <label class="radio">
          <input type="radio" value="flare" v-model="trick">
          Flare
        </label>
      </div>
      <div class="vss-select-block">
        <p class="label">Click Count</p>
        <label class="radio">
          <input type="radio" value="1" v-model="clickCount" checked="checked" :disabled="trick !== 'flare'">
          1
        </label>
        <label class="radio">
          <input type="radio" value="2" v-model="clickCount" :disabled="trick !== 'transformer' && trick !== 'flare'">
          2
        </label>
        <label class="radio">
          <input type="radio" value="3" v-model="clickCount" :disabled="trick !== 'transformer' && trick !== 'flare'">
          3
        </label>
        <label class="radio">
          <input type="radio" value="4" v-model="clickCount" :disabled="trick !== 'transformer'">
          4
        </label>
      </div>
      <div class="vss-select-block">
        <p class="label">Pattern</p>
        <label class="radio">
          <input type="radio" value="forward" v-model="pattern" checked="checked">
          Forward
        </label>
        <label class="radio">
          <input type="radio" value="backward" v-model="pattern">
          Backward
        </label>
        <label class="radio">
          <input type="radio" value="orbit" v-model="pattern">
          Orbit
        </label>
      </div>
      <div class="vss-select-block">
        <p class="label">Beat Length</p>
        <label class="radio">
          <input type="radio" value="6" v-model="beatLength" checked="checked">
          1
        </label>
        <label class="radio">
          <input type="radio" value="3" v-model="beatLength">
          1/2
        </label>
        <label class="radio">
          <input type="radio" value="2" v-model="beatLength">
          1/3
        </label>
      </div>
    </div>
    <div class="vss-button-container">
      <div class="vss-button-row is-flex is-flex-wrap-wrap columns is-justify-content-space-between">
        <a @click='clickAdd' class="button column">Add Trick</a>
        <a @click='addRest' class="button column">Add Rest</a>
        <a @click='allClear' class="button column">All Clear</a>
        <a @click='deleteOne' class="button column">Delete</a>
      </div>
      <div class="vss-button-row is-flex submit is-justify-content-space-between columns">
        <a @click="exportImg" class="button column">Export</a>
        <a v-if="!nonLogin" @click="save" class="button column" data-disable-with="Saving">Save</a>
      </div>
    </div>
  </template>
  <div v-show="exportImg" class="vss-img-wrapper"><img id="img"></div>
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
      clickCount: null,
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

    this.addBeatBgLine(this.totalBeatCount)

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
  computed: {},
  methods: {
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
    deleteOne() {
      if (this.chartCodes.length > 0) {
        const lastCode = this.chartCodes.pop()
        this.codeLayer.destroy()
        this.renderChartCodes(this.chartCodes)
        this.stage.draw()
        this.currentBeat -= lastCode.beatLength
      }
    },
    clickAdd() {
      if (this.currentBeat < 24) {
        if (this.pattern === 'orbit') {
          this.drawAddTrick('forward')
          this.drawAddTrick('backward')
        } else if (this.pattern !== 'orbit') {
          this.drawAddTrick(this.pattern)
        }
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
    transformer() {
      this.trick = 'transformer'
      if (!this.clickCount || this.clickCount === 1) {
        this.clickCount = 2
      }
    },
    flare() {
      this.trick = 'flare'
      if (!this.clickCount || this.clickCount === 4) {
        this.clickCount = 1
      }
    },
    addBgLine(x, stroke, dash = null) {
      this.bgLine = new Konva.Line({
        points: [x, this.stageHeight - 10, x, 0],
        stroke: stroke,
        strokeWidth: 1,
        dash: dash ? [3, 3] : null
      })
      this.bgLineLayer.add(this.bgLine)
    },
    addBgSolidLine(x) {
      this.addBgLine(x, '#c0c0c0')
    },
    addBgDashedLine(x) {
      this.addBgLine(x, '#d3d3d3', true)
    },
    addBeatBgLine(beatCount) {
      const solidLineWidth = (this.stageWidth - 20) / 4
      for (let i = 0; i <= beatCount; i++) {
        this.addBgSolidLine(i * solidLineWidth)
      }
      const dashedLineWidth = (this.stageWidth - 20) / 24
      for (let i = 1; i <= beatCount * 6; i++) {
        if (i % 6 !== 0) {
          this.addBgDashedLine(i * dashedLineWidth)
        }
      }
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
    faderPoints(code, faderPosition) {
      const faderPositionPx = this.toPixel(code.beatPosition) + this.toPixel(faderPosition)
      const x1 = faderPositionPx - 10
      const x2 = faderPositionPx + 10
      const chartHeight = this.stageHeight - 10
      if (code.pattern === 'forward') {
        const y = chartHeight - faderPosition / code.beatLength * chartHeight
        return [x1, y, x2, y]
      } else if (code.pattern === 'backward') {
        const y = faderPosition / code.beatLength * chartHeight
        return [x1, y, x2, y]
      }
    },
    addCodeLine(code) {
      let y1 = null
      let y2 = null
      let strokeWidth = null
      let stroke = null
      let layer = this.codeLayer
      const chartHeight = this.stageHeight - 10
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
        points: [this.toPixel(code.beatPosition), y1, this.toPixel(code.beatPosition) + this.toPixel(code.beatLength), y2],
        stroke: stroke,
        strokeWidth: strokeWidth,
        name: name,
      })
      layer.add(line)
      this.stage.add(layer)
      this.stage.draw()
    },
    renderChartCodes(chartCodes) {
      chartCodes.forEach((code) => {
        this.addCodeLine(code)
      })
      this.stage.draw()
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
    toPixel(beatPosition) {
      const oneBeatWidth = (this.stageWidth - 20) / 4
      return beatPosition * oneBeatWidth / 6
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
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    edit() {
      this.editing = true
      this.renderChartCodes(this.chartCodes)
    },
    save() {
      const convert = this.convert
      const promise = new Promise(function(resolve){
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
    }
  }
}
</script>
