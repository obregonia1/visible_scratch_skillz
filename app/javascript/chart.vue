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
    ref="chart-body"
    :editing="editing"
    :trick="trick"
    :title="title"
    :total-beat-count="totalBeatCount"
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
          <a class="button vss-bordered-button" @click="addChartCode(trick)"
            >Add Trick</a
          >
        </div>
        <div class="vss-button-column">
          <a class="button vss-bordered-button" @click="addChartCode('rest')"
            >Add Rest</a
          >
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
        <div v-if="nonLogin === 'false'" class="vss-button-column">
          <a
            class="button vss-save has-text-weight-bold"
            data-disable-with="Saving"
            @click="save"
            >Save</a
          >
        </div>
      </div>
    </div>
    <p v-if="nonLogin === 'true'" class="has-text-centered">
      <a href="/users/sign_in" class="has-text-weight-bold">Login</a> to save
      chart you made.
    </p>
  </template>
</template>

<script>
import ChartBody from './chartBody.vue';

export default {
  components: {
    ChartBody,
  },
  props: {
    chartId: { type: Number, required: true },
    currentUserId: { type: Number, required: true },
    nonLogin: { type: String, required: true },
    editing: { type: Boolean, require: true },
    title: { type: String },
    pattern: { type: String, require: true },
    trick: { type: String, require: true },
    beatLength: { type: Number, require: true },
    currentBeat: { type: Number, require: true },
    clickCount: { type: Number },
    userId: { type: Number },
    totalBeatCount: { type: Number },
  },
  data() {
    return {
      chartCodes: [],
      trick: 'baby',
      pattern: 'forward',
      beatLength: 6,
      currentBeat: 0,
      clickCount: 1,
      displayImg: false,
      title: '',
      imageUrl: '',
      loaded: null,
      editing: false,
      userId: '',
      totalBeatCount: 4,
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
          this.title = json.title;
          this.isPublic = json.is_public || false;
          this.chartCodes = JSON.parse(json.chart_code);
          this.$refs['chart-body'].renderChartCodes(this.chartCodes);
          const lastCode = this.chartCodes[this.chartCodes.length - 1];
          this.currentBeat = lastCode.beatPosition + lastCode.beatLength;
          this.loaded = true;
        })
        .catch((error) => {
          console.warn('Failed to parsing', error);
        });
    } else {
      this.editing = true;
    }
  },
  methods: {
    addChartCode(trick) {
      if (this.currentBeat < 24) {
        if (trick !== 'rest' && this.pattern === 'orbit') {
          this.pushChartCode(trick, 'forward');
          this.pushChartCode(trick, 'backward');
        } else {
          this.pushChartCode(trick, this.pattern);
        }
        const lastCode = this.chartCodes[this.chartCodes.length - 1];
        this.$refs['chart-body'].addCodeLineLayer(lastCode);
      }
    },
    pushChartCode(trick, pattern) {
      const code = {
        trick: trick,
        pattern: trick !== 'rest' ? pattern : null,
        beatLength: Number(this.beatLength),
        beatPosition: this.currentBeat,
        faderPositions: this.calcFaderPositions(pattern),
      };
      this.chartCodes.push(code);
      this.currentBeat += Number(this.beatLength);
      this.$refs['chart-body'].addCodeLineLayer(code);
    },
    allClear() {
      this.chartCodes.splice(0);
      this.$refs['chart-body'].deleteCodeLayer();
      this.currentBeat = 0;
    },
    destroy() {
      if (this.chartCodes.length > 0) {
        const lastCode = this.chartCodes.pop();
        this.currentBeat -= lastCode.beatLength;
        this.$refs['chart-body'].deleteCodeLayer();
      }
      this.$refs['chart-body'].renderChartCodes(this.chartCodes);
    },
    edit() {
      this.editing = true;
      this.$refs['chart-body'].renderChartCodes(this.chartCodes);
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
    save() {
      this.$refs['chart-body'].save();
    },
    exportImg() {
      this.$refs['chart-body'].exportImg();
    },
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]');
      return meta ? meta.getAttribute('content') : '';
    },
  },
};
</script>
