<template>
  <div id="chart">
  </div>
  <div class="select-container">
    <div class="select-trick">
      <p @click='baby'>baby</p>
      <p @click='chirp'>chirp</p>
      <p @click='slice'>slice</p>
    </div>
    <div class="select-pattern">
      <p @click='forward'>forward</p>
      <p @click='backward'>backward</p>
    </div>
    <div class="select-length">
      <p @click='normal'>normal</p>
      <p @click='double'>double</p>
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


    // this.line = new Konva.Line({
    //   points: [10, 0, 10, 100],
    //   stroke: 'black',
    //   strokeWidth: 1,
    //   dash: [3, 3]
    // })
    this.bgLayer.add(this.bgLine)
    this.stage.add(this.bgLayer)
    // this.layer = new Konva.Layer();
    // this.line = new Konva.Line({
    //   points: [0, 100, 100, 0, 200, 100, 300, 0],
    //   stroke: '#5a5454',
    //   strokeWidth: 2,
    //   scaleX: 0.5
    // });
    // this.layer.add(this.line);
    this.stage.add(this.layer);
    this.stage.draw()
  },
  computed: {
    render() {
      let line = this.line
      let layer = this.layer
      this.chartCodes.forEach(function (code) {
        if (code.pattern === 'forward') {
          line = new Konva.Line({
            points: [code.beatPosition * 100 / 6, 100, code.beatPosition * 100 / 6 + 100 * code.beatLength / 6, 0],
            stroke: '#5a5454',
            strokeWidth: 2,
          })
          layer.add(line)
          if (code.trick === 'slice') {
            line = new Konva.Line({
              points: [code.beatPosition * 100 / 6, 100, code.beatPosition * 100 / 6 + 10, 100],
              stroke: '#5a5454',
              strokeWidth: 2,
            })
          }
          layer.add(line)
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
      })
      this.stage.draw()
    }
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
      this.chartCodes.push({
        trick: this.trick,
        pattern: this.pattern,
        beatLength: this.beatLength,
        beatPosition: this.currentBeat
      })
      this.currentBeat += this.beatLength
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
    }
  }
}
</script>

<style scoped>
.container, .select-trick, .select-pattern, .select-length, .add {
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

.test {
  stroke: #0e736b;
  transform: translate(45px, 0) scale(-1, 1)
  /*transform: scaleX(0.5);*/
}

.backward {
  transform: translate(90px, 0) scale(-1, 1)
  /*scaleX(0.5);*/
}

.length3 {
  transform: scaleX(0.5);
}
</style>
