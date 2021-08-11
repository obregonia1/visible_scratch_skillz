<template>
  <div>
    <label for="chart_title">title</label>
    <input type="text" name="chart[title]" id="chart_title" v-model="title">
    <input type="hidden" name="chart[chart_code]" id="chart_code" :value="JSON.stringify(chartCodes)">
    <input type="hidden" name="chart[image]" id="chart_image" :value="imageUrl">
  </div>
  <div id="chart">
  </div>
  <div class="select-container">
    <div class="select-trick">
      <p @click='baby' :class="{isSelected: trick === 'baby'}">baby</p>
      <p @click='chirp' :class="{isSelected: trick === 'chirp'}">chirp</p>
      <p @click='slice' :class="{isSelected: trick === 'slice'}">slice</p>
      <p @click='chop' :class="{isSelected: trick === 'chop'}">chop</p>
      <p @click='transformer' :class="{isSelected: trick === 'transformer'}">transformer</p>
      <p @click='flare' :class="{isSelected: trick === 'flare'}">flare</p>
    </div>
    <div class="select-click" v-show="trick === 'transformer' || trick === 'flare'">
      <p @click="clickCount1" v-show="trick === 'flare'" :class="{isSelected: clickCount === 1}">1</p>
      <p @click="clickCount2" :class="{isSelected: clickCount === 2}">2</p>
      <p @click="clickCount3" :class="{isSelected: clickCount === 3}">3</p>
      <p @click="clickCount4" v-show="trick === 'transformer'" :class="{isSelected: clickCount === 4}">4</p>
    </div>
    <div class="select-pattern">
      <p @click='forward' :class="{isSelected: pattern === 'forward'}">forward</p>
      <p @click='backward' :class="{isSelected: pattern === 'backward'}">backward</p>
      <p @click='orbit' :class="{isSelected: pattern === 'orbit'}">orbit</p>
    </div>
    <div class="select-length">
      <p @click='normal' :class="{isSelected: beatLength === 6}">1</p>
      <p @click='double' :class="{isSelected: beatLength === 3}">1/2</p>
      <p @click='oneThird' :class="{isSelected: beatLength === 2}">1/3</p>
    </div>
    <div class="add">
      <p @click='clickAdd'>add</p>
      <p @click='addRest'>add rest</p>
      <p @click='allClear'>all clear</p>
      <p @click='deleteOne'>delete</p>
    </div>
  </div>
  <p @click="convert">Export</p>
  <div v-show="exportImg"><img id="img"></div>

</template>

<script>
import Konva from "konva";

export default {
  props: {
    chartId: {type: Number, required: true}
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
      exportImg: false,
      title: '',
      imageUrl: '',
      loaded: null,
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
    }

    this.stage = new Konva.Stage({
      container: 'chart',
      width: 500,
      height: 110
    })
    this.bgLineLayer = new Konva.Layer({
      name: 'bgLine'
    })

    for (let i = 0; i < 25; i++) {
      this.addBgDashedLine(i * 20)
    }

    for (let i = 0; i < 5; i++) {
      this.addBgSolidLine(i * 120)
    }

    this.bgLineLayer.offsetX(-10)
    this.bgLineLayer.offsetY(-10)
    this.codeLayer = new Konva.Layer({
      name: 'code'
    })

    this.codeLayer.offsetX(-10)
    this.codeLayer.offsetY(-10)
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
      this.currentBeat += this.beatLength
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
        beatLength: this.beatLength,
        beatPosition: this.currentBeat,
        faderPositions: this.calcFaderPositions(pattern),
      }
      this.chartCodes.push(code)
      this.currentBeat += this.beatLength
      this.addCodeLine(code)
    },
    baby() {
      this.trick = 'baby'
    },
    chirp() {
      this.trick = 'chirp'
    },
    slice() {
      this.trick = 'slice'
    },
    chop() {
      this.trick = 'chop'
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
    clickCount1() {
      this.clickCount = 1
    },
    clickCount2() {
      this.clickCount = 2
    },
    clickCount3() {
      this.clickCount = 3
    },
    clickCount4() {
      this.clickCount = 4
    },
    forward() {
      this.pattern = 'forward'
    },
    backward() {
      this.pattern = 'backward'
    },
    orbit() {
      this.pattern = 'orbit'
    },
    normal() {
      this.beatLength = 6
    },
    double() {
      this.beatLength = 3
    },
    oneThird() {
      this.beatLength = 2
    },
    addBgSolidLine(x1) {
      this.bgLine = new Konva.Line({
        points: [x1, 100, x1, 0],
        stroke: '#c0c0c0',
        strokeWidth: 1
      })
      this.bgLineLayer.add(this.bgLine)
    },
    addBgDashedLine(x1) {
      this.bgLine = new Konva.Line({
        points: [x1, 100, x1, 0],
        stroke: '#d3d3d3',
        strokeWidth: 1,
        dash: [3, 3]
      })
      this.bgLineLayer.add(this.bgLine)
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
      if (code.pattern === 'forward') {
        const y = 100 - faderPosition / code.beatLength * 100
        return [x1, y, x2, y]
      } else if (code.pattern === 'backward') {
        const y = faderPosition / code.beatLength * 100
        return [x1, y, x2, y]
      }
    },
    addCodeLine(code) {
      let y1 = null
      let y2 = null
      let strokeWidth = null
      let stroke = null
      let layer = this.codeLayer
      if (code.trick !== 'rest') {
        y1 = code.pattern === 'forward' ? 100 : 0
        y2 = code.pattern === 'forward' ? 0 : 100
        strokeWidth = 2
        stroke = '#5a5454'
        name = 'code'
        if (code.trick !== 'baby') {
          this.drawFaderLine(code, layer)
        }
      } else if (code.trick === 'rest') {
        y1 = 100
        y2 = 100
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
        return [pattern === 'forward' ? this.beatLength : 0]
      } else if (this.trick === 'slice') {
        return [pattern === 'forward' ? 0 : this.beatLength]
      } else if (this.trick === 'chop') {
        return [0, this.beatLength]
      } else if (this.trick === 'transformer') {
        let faderPositions = [0]
        for (let n = 1; n <= this.clickCount; n++) {
          faderPositions.push(this.beatLength * n / this.clickCount)
        }
        return faderPositions
      } else if (this.trick === 'flare') {
        let faderPositions = []
        for (let n = 1; n <= this.clickCount; n++) {
          faderPositions.push(this.beatLength * n / (this.clickCount + 1))
        }
        return faderPositions
      }
    },
    toPixel(beatPosition) {
      return beatPosition * 120 / 6
    },
    convert() {
      const imageStage = new Konva.Stage({
        container: 'img',
        width: 500,
        height: 160,
      })
      const bgColor = new Konva.Rect({
        width: 500,
        height: 160,
        fill: 'white'
      })

      const bgColorLayer = new Konva.Layer({
        name: 'bgColor'
      })
      bgColorLayer.add(bgColor)
      imageStage.add(bgColorLayer)
      const bgLineLayer = this.bgLineLayer.clone()
      bgLineLayer.offsetX(-10)
      bgLineLayer.offsetY(-30)
      imageStage.add(bgLineLayer)

      const textLayer = new Konva.Layer({
        name: 'text'
      })
      const title = new Konva.Text({
        x: this.stage.width() / 2,
        y: 10,
        text: this.title,
        fill: 'black',
        fontSize: 16,
      })
      title.offsetX(title.width() / 2)
      textLayer.add(title)

      const appName = new Konva.Text({
        x: this.stage.width() / 2,
        y: 140,
        text: '©︎Invisible Scratch Skillz',
        fill: 'black',
        fontSize: 12,
      })
      appName.offsetX(appName.width() / 2)
      textLayer.add(appName)

      const codeLayer = this.codeLayer.clone()
      codeLayer.offsetX(-10)
      codeLayer.offsetY(-30)
      const restLines = codeLayer.getChildren(line => {
        return line.attrs.name === 'rest'
      })
      restLines.map(line => {
        line.setAttr('visible', false)
      })

      imageStage.add(codeLayer)
      imageStage.add(textLayer)

      this.imageUrl = imageStage.toDataURL({
        pixelRatio: 2
      })
      // const img = document.getElementById("img")
      // img.src = imageUrl
      // this.exportImg = true

    },
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
  }
}
</script>

<style scoped>
.select-trick, .select-pattern, .select-length, .add, .select-click {
  display: flex;
}

.select-trick p {
  margin: 10px;
}

.select-pattern p {
  margin: 10px;
}

.select-length p {
  margin: 10px;
}

.add p {
  margin: 10px;
}

.select-click p {
  margin: 10px;
}

svg {
  width: 90px;
  height: 92px;
}

line {
  stroke: rgb(90, 84, 84);
  stroke-width: 2px;
}

.isSelected {
  background-color: #9f7cba;
}

img {
  width: 500px;
  height: 160px;
}
</style>
