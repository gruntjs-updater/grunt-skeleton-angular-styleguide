angular.module('styleguide.component', ['styleguide.common'])
  .controller('ComponentCtrl', function ($scope, $stateParams, StyleguideData) {
    var componentName = $stateParams.name;

    $scope.ready = false;

    StyleguideData.getComponentsData(componentName).then(function (component) {
      $scope.ready     = true;
      $scope.component = component;
      $scope.data      = component.data;
      $scope.options   = { };
      _.each(component.options, function (optionData, name) {
        $scope.options[name] = optionData.default;
      });

    });

    $scope.isComplexData = function (data) {
      return typeof(data) === 'object';
    }



    $scope.tabs   = [ 'view', 'source', 'html'];
    $scope.tabIdx = 0;
    $scope.selectTab = function (index) {
      $scope.tabIdx = index;
    }
  }).directive('complexDataField', function () {
    return {
      restrict: 'A',
      require: '?ngModel',
      link: function (scope, element, attrs, ngModel) {

        ngModel.$parsers.push(function toModel(input) {
          return JSON.parse(input);
        });

        ngModel.$formatters.push(function toView(input) {
          return JSON.stringify(input, undefined, 2);
        });
      }
    }
  });
