<template>
  <div id="chart">
  </div>
  <div class="select-container">
    <div class="select-trick">
      <p @click='baby' :class="{isSelected: trick === 'baby'}">baby</p>
      <p @click='chirp' :class="{isSelected: trick === 'chirp'}">chirp</p>
      <p @click='slice' :class="{isSelected: trick === 'slice'}">slice</p>
    </div>
    <div class="select-pattern">
      <p @click='forward' :class="{isSelected: pattern === 'forward'}">forward</p>
      <p @click='backward' :class="{isSelected: pattern === 'backward'}">backward</p>
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
  {{ chartCodes }}


</template>

<script>
import Konva from "konva";

export default {
  data() {
    return {
      chartCodes: [],
      trick: 'baby',
      pattern: 'forward',
      beatLength: 6,
      stage: {},
      currentBeat: 0,
      codeLayer: null,
      faderPosition: null,
    }
  },
  mounted() {
    this.stage = new Konva.Stage({
      container: 'chart',
      width: 481,
      height: 100
    })
    this.bgLayer = new Konva.Layer()

    for (let i = 0; i < 25; i++) {
      this.addBgDashedLine(i * 20)
    }

    for (let i = 0; i < 5; i++) {
      this.addBgSolidLine(i * 120)
    }

    this.codeLayer = new Konva.Layer()

    this.bgLayer.add(this.bgLine)
    this.stage.add(this.bgLayer)
    this.stage.draw()
  },
  computed: {},
  methods: {
    addRest() {
      this.chartCodes.push({
        trick: 'rest',
        pattern: null,
        beatLength: this.beatLength,
        beatPosition: this.currentBeat
      })
      this.currentBeat += this.beatLength
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
      const code = {
        trick: this.trick,
        pattern: this.pattern,
        beatLength: this.beatLength,
        beatPosition: this.currentBeat,
        faderPosition: this.calcFaderPosition(),
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
    forward() {
      this.pattern = 'forward'
    },
    backward() {
      this.pattern = 'backward'
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
      this.bgLayer.add(this.bgLine)
    },
    addBgDashedLine(x1) {
      this.bgLine = new Konva.Line({
        points: [x1, 100, x1, 0],
        stroke: '#d3d3d3',
        strokeWidth: 1,
        dash: [3, 3]
      })
      this.bgLayer.add(this.bgLine)
    },
    drawFaderLine(code, layer) {
      const faderLine = new Konva.Line({
        points: this.faderPoints(code),
        stroke: '#5a5454',
        strokeWidth: 1,
      })
      layer.add(faderLine)
    },
    faderPoints(code) {
      const faderPosition = this.toPixel(code.beatPosition) + this.toPixel(code.faderPosition)
      const x1 = faderPosition - 10
      const x2 = faderPosition + 10
      if (code.pattern === 'forward') {
        const y = 100 - code.faderPosition / code.beatLength * 100
        return [x1, y, x2, y]
      } else if (code.pattern === 'backward') {
        const y = code.faderPosition / code.beatLength * 100
        return [x1, y, x2, y]
      }
    },
    addCodeLine(code) {
      if (code.trick !== 'rest') {
      let line = null
      let layer = this.codeLayer
      const y1 = code.pattern === 'forward' ? 100 : 0
      const y2 = code.pattern === 'forward' ? 0 : 100
      line = new Konva.Line({
        points: [this.toPixel(code.beatPosition), y1, this.toPixel(code.beatPosition) + this.toPixel(code.beatLength), y2],
        stroke: '#5a5454',
        strokeWidth: 2,
      })
        layer.add(line)
        if (code.trick !== ('baby' || 'rest')) {
          this.drawFaderLine(code, layer)
        }
      this.stage.add(layer)
      this.stage.draw()
      }
    },
    renderChartCodes(chartCodes) {
      chartCodes.forEach((code) => {
        this.addCodeLine(code)
      })
      this.stage.draw()
    },
    calcFaderPosition() {
      if (this.trick === 'chirp') {
        return this.pattern === 'forward' ? this.beatLength : 0
      } else if (this.trick === 'slice') {
        return this.pattern === 'forward' ? 0 : this.beatLength
      }
    },
    toPixel(beatPosition) {
      return beatPosition * 120 / 6
    }
  }
}
</script>

<style scoped>
.select-trick, .select-pattern, .select-length, .add {
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
</style>
