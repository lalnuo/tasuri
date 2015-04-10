var tasuriApp = angular.module('tasuriApp', ['ui.router', 'ngCookies']).config(['$httpProvider', function($httpProvider) {
  $httpProvider.defaults.withCredentials = true;
}]);
var server = 'http://localhost:3000';

tasuriApp.controller('HouseholdController', function($scope, $stateParams, $state, householdService, $http, household) {
  if (!$stateParams.name) {
    $state.go('error')
    return;
  }
  $scope.create = function() {
    var promise = householdService.createHousehold($stateParams.name, $scope.password)
    promise.then(function(data) {

      $state.go('household', {name: $stateParams.name})
    });
  }

  var currentState = $state.current.name
  if (currentState === 'household') {
      if (household.status === householdService.SHOW_HOUSEHOLD) {
        $scope.name = household.data.name;
        $scope.userBalances = household.data.balances;
        $scope.users = household.data.users;
      } else if (household.status === householdService.AUTHENTICATION_REQUIRED) {
        $state.go('authentication', {'name': $stateParams.name});
      } else if (household.status === householdService.NEW_HOUSEHOLD) {
        $state.go('new_household', {'name': $stateParams.name});
      } else {
        $state.go('error');
      }
  } else if (currentState === 'new_household') {
    $scope.name = $stateParams.name;
  }
});

tasuriApp.controller('AuthenticationController', function($scope, $stateParams, $state, authenticationService) {
  $scope.auth = function() {
    var promise = authenticationService.auth($stateParams.name, $scope.householdPassword);
    promise.then(function(data) {
      if (data) {
        $state.go('household', {name: $stateParams.name})
      }
    });
  }
});

tasuriApp.service('authenticationService', function($http, $q) {
  var deferred = $q.defer();
  this.auth = function(name, password) {
    $http.post(server + '/authenticate', {name: name, password: password}).success(function(data) {
      deferred.resolve(data);
    });
    return deferred.promise;
  }

})

tasuriApp.service('householdService', function($http, $q) {

  this.NEW_HOUSEHOLD = 'ok',
  this.SHOW_HOUSEHOLD = 'showHousehold'
  this.AUTHENTICATION_REQUIRED = 'authentication',

  this.getHousehold = function(householdName) {
    var self = this;
    var deferred = $q.defer();
    $http.get(server + '/households/' + householdName)
    .success(function(data) {
      deferred.resolve({status: self.SHOW_HOUSEHOLD, data: data});
    })
    .error(function(data, statusCode){
      if (statusCode === 403) {
        deferred.resolve({status: self.AUTHENTICATION_REQUIRED})
      } else {
        deferred.resolve({status: self.NEW_HOUSEHOLD})
      }
    })

    return deferred.promise;
  }

  this.createHousehold = function(name, password) {
    var deferred = $q.defer();
    $http.post(server + '/households', {name: name, password: password}).success(function() {
      deferred.resolve(true);
    });
    return deferred.promise;
  }
});


tasuriApp.config(function($stateProvider, $urlRouterProvider) {
  //
  // For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise("error");
  //
  // Now set up the states
  $stateProvider
    .state('household', {
      url: "/households/:name",
      resolve: {household: function(householdService, $stateParams) {
        return householdService.getHousehold($stateParams.name)
      }},
      templateUrl: "partials/household.html",
      controller: 'HouseholdController',
    })
    .state('authentication', {
      templateUrl: 'partials/auth.html',
      params: {name: null},
      controller: 'AuthenticationController'
    })
    .state('new_household', {
      templateUrl: 'partials/new_household.html',
      resolve: {household: function() {return {}}},
      params: {name: null},
      controller: 'HouseholdController'
    })
    .state('error', {
      templateUrl: 'partials/error.html',
    })
});