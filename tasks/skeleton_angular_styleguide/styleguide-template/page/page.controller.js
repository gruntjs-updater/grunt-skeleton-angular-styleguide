angular
  .module('styleguide.page', ['styleguide.common'])
  .controller('PageCtrl', function ($scope, $stateParams, $q, StyleguideData) {
    $scope.pageName = $stateParams.pageName;
  });
