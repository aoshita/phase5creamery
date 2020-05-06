////////////////////////////////////////////////
//// Setting up a general ajax method to handle
//// transfer of data between client and server
////////////////////////////////////////////////
function run_ajax(method, data, link, callback=function(res){dosages.get_dosages()}){
  $.ajax({
    method: method,
    data: data,
    url: link,
    success: function(res) {
      dosages.errors = {};
      callback(res);
    },
    error: function(res) {
      console.log("error");
      dosages.errors = res.responseJSON;
    }
  })
}

//////////////////////////////////////////////
//// A component to create a dosage list item
//////////////////////////////////////////////
Vue.component('dosage-row', {
  // Start with the template: two methods to consider...
  // (1) defining where to look for the HTML template in the index view
  // template: '#job-row',
  // _or_ (2) define it directly in the js file as such:
  template: `
    <li>
      <a v-on:click="remove_record(job)" class="remove">x&nbsp;&nbsp;</a>
      {{ job.medicine_name }}:&nbsp;&nbsp;
      {{ job.units_given }}&nbsp;units
    </li>
  `,

  // Passed elements to the component from the Vue instance
  props: {
    job: Object
  },

  // Behaviors associated with this component
  methods: {
    remove_record: function(job){
      run_ajax('DELETE', {job: job}, '/jobs/'.concat(job['id'], '.json'));
    }
  }
});

/////////////////////////////////////////
//// A component for adding a new job
/////////////////////////////////////////
var new_form = Vue.component('new-job-form', {
  template: '#job-form-template',

  mounted() {
    // need to reconnect the materialize select javascript
    $('#dosage_medicine_id').material_select()
  },

  data: function () {
    return {
        medicine_id: 0,
        visit_id: 0,
        units_given: 0,
        discount: 0,
        errors: {}
    }
  },

  methods: {
    submitForm: function (x) {
      new_post = {
        medicine_id: this.medicine_id,
        visit_id: this.visit_id,
        units_given: this.units_given,
        discount: this.discount
      }
      run_ajax('POST', {dosage: new_post}, '/dosages.json')
      this.switch_modal()
    }
  },
})


//////////////////////////////////////////
////***  The Vue instance itself  ***////
/////////////////////////////////////////
var dosages = new Vue({

  el: '#dosage_handling',

  data: {
    visit_id: 0,
    dosages: [],
    modal_open: false,
    errors: {}
  },

  created() {
    // read the visit_id from the page when instance created
    this.visit_id = $('#visit_id').val();
  },

  methods: {
    switch_modal: function(event){
      this.modal_open = !(this.modal_open);
    },

    get_dosages: function(){
      run_ajax('GET', {}, '/visits/'.concat(this.visit_id, '/dosages.json'), function(res){dosages.dosages = res});
    }
  },

  mounted: function(){
    this.get_dosages();
  }
});
