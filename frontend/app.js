var tasuriApp = angular.module('tasuriApp', ['ui.router', 'ngCookies']).config(['$httpProvider', function($httpProvider) {
  $httpProvider.defaults.withCredentials = true;
}]);
var server = 'http://localhost:3000';

tasuriApp.controller('HouseholdController', function($scope, $stateParams, $state, householdService, $http) {
  if ($stateParams.name) {
    var promise = householdService.getHousehold($stateParams.name)

    promise.then(function(data) {
      if (data.status === householdService.SHOW_HOUSEHOLD) {
        $scope.name = data.data.name;
        $scope.userBalances = data.data.balances;
        $scope.users = data.data.users
      } else if (data.status === householdService.AUTHENTICATION_REQUIRED) {
        $state.go('authentication', {'name': $stateParams.name});
      } else {

      }
    });
  }
});

tasuriApp.controller('AuthenticationController', function($scope, $stateParams, $state, authenticationService) {
  $scope.auth = function() {
    var promise = authenticationService.auth($scope.householdName, $scope.householdPassword);
    promise.then(function(data) {
      if (data) {
        $state.go('households', {name: $stateParams.name})
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

  this.OK = 'ok',
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
        console.log("Not yet created")
      }
    })
    

    return deferred.promise;
  }
});


tasuriApp.config(function($stateProvider, $urlRouterProvider) {
  //
  // For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise("/");
  //
  // Now set up the states
  $stateProvider
    .state('households', {
      url: "/households/:name",
      templateUrl: "partials/household.html",
      controller: 'HouseholdController',
    })
    .state('authentication', {
      templateUrl: 'partials/authentication.html',
      params: {name: null},
      controller: 'AuthenticationController'
    })
});