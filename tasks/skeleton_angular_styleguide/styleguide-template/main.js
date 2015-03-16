'use strict';

angular
  .module('styleguide.common', [
    'ui.router',
    'angular.filter'
  ])
  .service('StyleguideData', function ($http, $q) {
    var componentsData = [];
    var colorsData     = {};
    var typographyData = {};
    var pagesData      = [];


    var data = {};
    return {
      getComponentsData: getComponentsData,
      getTypographyData: getTypographyData,
      getColorsData    : getColorsData,
      getPagesData     : getPagesData,
      getData          : getData
    }

    function filterComponents (components, componentName) {
      if (!componentName) {
        return components;
      }
      return _.find(components, function (c) { return c.name === componentName });
    }

    function getComponentsData (componentName) {
      var deferred = $q.defer();
      if (componentsData.length) {
        deferred.resolve(filterComponents(componentsData, componentName));
      } else {
        $http
          .get('data/components.json')
          .success(function (result) {
            deferred.resolve(filterComponents(result, componentName));
            componentsData = result;
          });
      }

      return deferred.promise;
    }

    function getColorsData () {
      var deferred = $q.defer();
      if (!_.isEmpty(colorsData)) {
        deferred.resolve(colorsData);
      } else {
        $http
          .get('data/colors.json')
          .success(function (result) {
            deferred.resolve(result);
            colorsData = result;
          })
      }
      return deferred.promise;
    }

    function getTypographyData () {
      var deferred = $q.defer();
      if (!_.isEmpty(typographyData)) {
        deferred.resolve(typographyData);
      } else {
        $http
          .get('data/typography.json')
          .success(function (result) {
            deferred.resolve(result);
            typographyData = result;
          })
      }
      return deferred.promise;
    }

    function getPagesData () {
      var deferred = $q.defer();
      if (!_.isEmpty(pagesData)) {
        deferred.resolve(pagesData);
      } else {
        $http
          .get('data/pages.json')
          .success(function (result) {
            deferred.resolve(result);
            pagesData = result;
          })
      }
      return deferred.promise;
    }

    function getData (name) {
      var deferred = $q.defer();
      if (data[name]) {
        deferred.resolve(data[name]);
      } else {
        $http
          .get('data/' + name + '.json')
          .success(function (result) {
            deferred.resolve(result);
            data[name] = result;
          })
      }
      return deferred.promise;
    }
  });


angular
  .module('styleguide', [
    'styleguide.common',
    'styleguide.layout.sidebar',

    'styleguide.dashboard',
    'styleguide.component',
    'styleguide.colors',
    'styleguide.typography',
    'styleguide.page',

    'app.widgets'
  ])
  .config(function ($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('dashboard', {
        url: '/',
        templateUrl: 'dashboard/dashboard.html',
        controller: 'DashboardCtrl'
      })
      .state('component', {
        url: '/component/:name',
        templateUrl: 'component/component.html',
        controller: 'ComponentCtrl'
      })
      .state('colors', {
        url: '/colors',
        templateUrl: 'colors/colors.html',
        controller: 'ColorsCtrl'
      })
      .state('typography', {
        url: '/typography',
        templateUrl: 'typography/typography.html',
        controller: 'TypographyCtrl'
      })
      .state('page', {
        url: 'page/:pageName',
        templateUrl: 'page/page.html',
        controller: 'PageCtrl'
      })
      ;

    $urlRouterProvider.otherwise('/');
  })
  .controller('MainCtrl', function ($scope) {

  });
