angular
  .module('styleguide.page', ['styleguide.common'])
  .controller('PageCtrl', function ($scope, $stateParams, $q, StyleguideData) {
    $scope.pageName = $stateParams.pageName;

    $scope.patients = [];
    $scope.referals = [];
    $scope.patientReferals = [];
    // StyleguideData.getData('patients').then(function (receivedData) {
    //   $scope.patients = receivedData;
    // });

    // StyleguideData.getData('referals').then(function (receivedData) {
    //   $scope.referals = receivedData;
    // });

    StyleguideData.getData('patient-referals').then(function (receivedData) {
      $scope.patientReferals = receivedData;
      console.log('$scope.patientReferals', $scope.patientReferals);
    });

    var ALL_PATIENTS = [{"id":0,"firstname":"Arnold","lastname":"Meier","birthday":"01.12.2013","pendingReferals":0},{"id":1,"firstname":"Gertrud","lastname":"Meier","birthday":"01.12.2013","pendingReferals":0},{"id":2,"firstname":"Maria","lastname":"Bartgrass","birthday":"01.12.2013","pendingReferals":2},{"id":3,"firstname":"Angela","lastname":"Krebsschere","birthday":"01.12.2013","pendingReferals":0},{"id":4,"firstname":"Priska","lastname":"Drahtschmiele","birthday":"01.12.2013","pendingReferals":0,"exitOn":"4.1.2015"},{"id":5,"firstname":"Hedwig","lastname":"Kornrade","birthday":"01.12.2013","pendingReferals":0},{"id":6,"firstname":"Anne-Marie","lastname":"Seggae","birthday":"01.12.2013","pendingReferals":0},{"id":7,"firstname":"Christian","lastname":"Holunder","birthday":"01.12.2013","pendingReferals":0},{"id":8,"firstname":"Franziska","lastname":"Trespe","birthday":"01.12.2013","pendingReferals":0},{"id":9,"firstname":"Rosmarie","lastname":"Glockenblume","birthday":"01.12.2013","pendingReferals":0},{"id":10,"firstname":"Gertrud","lastname":"Heckenkirsche","birthday":"01.12.2013","pendingReferals":1}];
    $scope.hasMorePatients = true;
    $scope.patients = ALL_PATIENTS.slice(0, 5);
    $scope.loadMorePatients = function (index) {
      var deferred = $q.defer();
      if (ALL_PATIENTS.length > index * 5) {
          var itemsToAppend = ALL_PATIENTS.slice(index * 5, (index + 1) * 5);
          deferred.resolve({
              itemsToAppend: itemsToAppend,
              hasMoreItems: ALL_PATIENTS.length > (index + 1) * 5
          });
      }

      return deferred.promise;
    }

    $scope.selectedTab = 0;



    var All_REFERALS = [{"id":0,"patientId":1,"name":"Maria Bartgrass","birthday":"24.09.1920","receiver":"Borner, Markus","praxis":"Endokrinologie und Diabetologie"},{"id":1,"patientId":1,"name":"Maria Bartgrass","birthday":"24.09.1920","receiver":"Spitalzentrum Biel AG, Centre hospitalier Bienne SA","praxis":"Zentrumsvergor-gung, Niveau 2"},{"id":2,"patientId":2,"name":"Gertrud Heckenkirsche","birthday":"24.09.1983","receiver":"Messerli-Gerhards, Daniela, Biel/Bienne","praxis":"Ophthalmologie"},{"id":3,"patientId":3,"name":"Louis Beifuss","birthday":"24.09.1920","receiver":"Viollier AG, Allschwil","praxis":"Mikrobiologie/Genetik-Laboratorien "},{"id":4,"patientId":4,"name":"Corinne Müller","birthday":"24.09.1920","receiver":"Häusler, Christoph, Thun","praxis":"Ophthalmologie"},{"id":5,"patientId":5,"name":"Angela Allermannsharnisch","birthday":"24.09.1920","receiver":"Lacinoglu, Mihran, Biel/Bienne","praxis":"Psychiatrie und Psychotherapie"},{"id":6,"patientId":6,"name":"Hedwig Kornrade","birthday":"24.09.1920","receiver":"Colque, Gentiane","praxis":"Psihiatrie und Psychotherapie"},{"id":7,"patientId":7,"name":"Anne-Marie Silge","birthday":"24.09.1920","receiver":"Riechers, Eberhard","praxis":"Psihiatrie und Psychotherapie"},{"id":8,"patientId":7,"name":"Anne-Marie Silge","birthday":"24.09.1920","receiver":"Spitalzentrum Biel AG, Centre hospitalier Bienne SA","praxis":"Zentrumsversor-gung, Niveau 2"},{"id":9,"patientId":8,"name":"Christian Holunder","birthday":"24.09.1920","receiver":"Viollier AG, Allschwil","praxis":"Mikrobiologie/Genetik-Laboratorien"}];
    $scope.hasMoreReferals = true;
    $scope.referals = All_REFERALS.slice(0, 5);
    $scope.loadMoreReferals = function (index) {
      var deferred = $q.defer();
      if (All_REFERALS.length > index * 5) {
          var itemsToAppend = All_REFERALS.slice(index * 5, (index + 1) * 5);
          deferred.resolve({
              itemsToAppend: itemsToAppend,
              hasMoreItems: All_REFERALS.length > (index + 1) * 5
          });
      }
      return deferred.promise;
    }
  });
