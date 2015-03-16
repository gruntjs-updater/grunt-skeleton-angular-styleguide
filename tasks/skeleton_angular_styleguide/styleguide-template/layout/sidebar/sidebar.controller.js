angular.module('styleguide.layout.sidebar', [ 'styleguide.common' ])
  .controller('SidebarCtrl', function ($scope, StyleguideData) {

    StyleguideData.getComponentsData().then(function (components) {
      $scope.components = components;
    });

    StyleguideData.getPagesData().then(function (pages) {
      console.log('loaded pages', pages);
      $scope.pages = pages;
    });

  });
