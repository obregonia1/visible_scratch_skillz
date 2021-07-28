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
      <p @click='normal' :class="{isSelected: beatLength === 6}">normal</p>
      <p @click='double' :class="{isSelected: beatLength === 3}">double</p>
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
      layer: null,
      line: null,
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

    this.layer = new Konva.Layer()

    this.bgLayer.add(this.bgLine)
    this.stage.add(this.bgLayer)
    this.stage.draw()
  },
  computed: {
    // render() {
    //   let line = this.line
    //   let layer = this.layer
    //   this.chartCodes.forEach(function (code) {
    //     if (code.pattern === 'forward') {
    //       line = new Konva.Line({
    //         points: [code.beatPosition * 120 / 6, 100, code.beatPosition * 120 / 6 + 120 * code.beatLength / 6, 0],
    //         stroke: '#5a5454',
    //         strokeWidth: 2,
    //       })
    //       layer.add(line)
    //       // this.drawFaderLine(code, layer)
    //       // layer.add(this.drawFaderLine(code))
    //       console.log('hoge')
    //     } else if (code.pattern === 'backward') {
    //       line = new Konva.Line({
    //         points: [code.beatPosition * 100 / 6, 0, code.beatPosition * 100 / 6 + 100, 100],
    //         stroke: '#5a5454',
    //         strokeWidth: 2,
    //       })
    //       layer.add(line)
    //       if (code.trick === 'slice') {
    //         line = new Konva.Line({
    //           points: [code.beatPosition * 100 / 6 + 90, 100, code.beatPosition * 100 / 6 + 100, 100],
    //           stroke: '#5a5454',
    //           strokeWidth: 2,
    //         })
    //       }
    //       layer.add(line)
    //     }
    //   })
    //   this.stage.add(layer)
    //   this.stage.draw()
    // }
  },
  methods: {
    addRest() {
      this.chartCodes.push({trick: 'rest'})
    },
    allClear() {
      this.chartCodes.splice(0)
    },
    deleteOne() {
      this.chartCodes.pop()
    },
    clickAdd() {
      const code = {
        trick: this.trick,
        pattern: this.pattern,
        beatLength: this.beatLength,
        beatPosition: this.currentBeat
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
      let faderLine = new Konva.Line({
        points: this.faderPoints(code),
        stroke: '#5a5454',
        strokeWidth: 2,
      })
      layer.add(faderLine)
    },
    faderPoints(code) {
      if (code.trick === 'chirp') {
        return [code.beatPosition * 120 / 6 + 110, 1, code.beatPosition * 120 / 6 + 120, 1]
      } else if (code.trick === 'slice') {
        return [code.beatPosition * 120 / 6, 99, code.beatPosition * 120 / 6 + 10, 99]
      }
    },
    addCodeLine(code) {
      let line = this.line
      let layer = this.layer
      if (code.pattern === 'forward') {
        line = new Konva.Line({
          points: [code.beatPosition * 120 / 6, 100, code.beatPosition * 120 / 6 + 120 * code.beatLength / 6, 0],
          stroke: '#5a5454',
          strokeWidth: 2,
        })
        layer.add(line)
        if (code.trick !== 'baby') {
          this.drawFaderLine(code, layer)
        }
      } else if (code.pattern === 'backward') {
        line = new Konva.Line({
          points: [code.beatPosition * 100 / 6, 0, code.beatPosition * 100 / 6 + 100, 100],
          stroke: '#5a5454',
          strokeWidth: 2,
        })
        layer.add(line)
        if (code.trick === 'slice') {
          line = new Konva.Line({
            points: [code.beatPosition * 100 / 6 + 90, 100, code.beatPosition * 100 / 6 + 100, 100],
            stroke: '#5a5454',
            strokeWidth: 2,
          })
        }
        layer.add(line)
      }
      this.stage.add(layer)
      this.stage.draw()
    },
    renderChartCodes(chartCodes) {
      chartCodes.forEach(function (code) {
        this.addCodeLine(code)
      })
    },
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
