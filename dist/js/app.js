var emeals;

emeals = angular.module('emeals', ['blueimp.fileupload', 'emeals.services', 'emeals.directives', 'emeals.filters', 'emeals.controllers']);

emeals.config(function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: 'views/meals/home.html'
  }).when('/meals/:mealId', {
    templateUrl: 'views/meals/show.html',
    controller: 'MealShowCtrl',
    resolve: {
      meal: [
        'Meals', function(Meals) {
          return Meals.load();
        }
      ]
    }
  }).when('/meals/:mealId/edit', {
    templateUrl: 'views/meals/edit.html',
    controller: 'MealEditCtrl',
    resolve: {
      meal: [
        'Meals', function(Meals) {
          return Meals.load();
        }
      ]
    }
  }).when('/plans', {
    templateUrl: 'views/plans/list.html',
    controller: 'PlanListCtrl',
    resolve: {
      pastPlans: [
        'Plans', function(Plans) {
          return Plans.past();
        }
      ],
      futurePlans: [
        'Plans', function(Plans) {
          return Plans.future();
        }
      ],
      current: [
        'Plans', function(Plans) {
          return Plans.load('current');
        }
      ]
    }
  }).when('/plans/new', {
    templateUrl: 'views/plans/edit.html',
    controller: 'PlanNewCtrl'
  }).when('/plans/:id', {
    templateUrl: 'views/plans/show.html',
    controller: 'PlanShowCtrl',
    resolve: {
      plan: [
        'Plans', function(Plans) {
          return Plans.load();
        }
      ]
    }
  }).when('/plans/:id/shopping_list', {
    templateUrl: 'views/plans/shopping_list.html',
    controller: 'ShoppingListCtrl',
    resolve: {
      plan: [
        'Plans', function(Plans) {
          return Plans.load();
        }
      ],
      shoppingList: [
        'Plans', function(Plans) {
          return Plans.shoppingList();
        }
      ]
    }
  }).when('/plans/:id/edit', {
    templateUrl: 'views/plans/edit.html',
    controller: 'PlanEditCtrl',
    resolve: {
      plan: [
        'Plans', function(Plans) {
          return Plans.load();
        }
      ]
    }
  }).otherwise({
    redirectTo: '/'
  });
});

emeals.config(function($locationProvider) {
  return $locationProvider.html5Mode(true);
});

;var services;

services = angular.module('emeals.services', ['restangular']);

services.config(function(RestangularProvider) {
  RestangularProvider.setBaseUrl("/api");
  return RestangularProvider.setRestangularFields({
    id: "_id"
  });
});

;angular.module('emeals.filters', []);

_.mixin(_.string.exports());

;angular.module('emeals.directives', ['emeals.services']);

;angular.module('emeals.controllers', ['emeals.services']);

;angular.module('emeals.controllers').controller('NavigationCtrl', function($scope, Navigation) {
  return $scope.nav = Navigation;
});

;angular.module('emeals.controllers').controller('UploadCtrl', function($scope) {
  $scope.options = {
    autoUpload: true,
    dropZone: $("#sidebar")
  };
  $scope.isUploading = false;
  $scope.$on('fileuploadalways', function() {
    return $scope.isUploading = false;
  });
  return $scope.$on('fileuploadstart', function() {
    return $scope.isUploading = true;
  });
});

;angular.module('emeals.controllers').controller('DishEditCtrl', function($scope) {
  $scope.unitChoices = ["teaspoon", "tablespoon", "cup", "oz", "lb", "clove"].sort();
  $scope.$watch('meal', function() {
    return $scope.dish = $scope.meal[$scope.type];
  });
  $scope.remove = function(index) {
    return $scope.dish.ingredients.splice(index, 1);
  };
  return $scope.add = function() {
    var _base;
    (_base = $scope.dish).ingredients || (_base.ingredients = []);
    return $scope.dish.ingredients.push({
      amount: "",
      unit: "",
      description: ""
    });
  };
});

;angular.module('emeals.controllers').controller('DishShowCtrl', function($scope) {
  return $scope.$watch('meal', function() {
    return $scope.dish = $scope.meal[$scope.type];
  });
});

;angular.module('emeals.controllers').controller('MealEditCtrl', function($scope, $rootScope, $location, meal, Errors) {
  $scope.meal = meal;
  $scope.cancel = function() {
    return $location.path("/meals/" + meal._id);
  };
  return $scope.save = function() {
    return meal.put().then(function() {
      $rootScope.$broadcast("mealupdated", meal);
      return $location.path("/meals/" + meal._id);
    }, Errors.defaultHandler);
  };
});

;angular.module('emeals.controllers').controller('MealShowCtrl', function($scope, $rootScope, $location, $window, meal) {
  $scope.meal = meal;
  return $scope.remove = function() {
    if ($window.confirm("Are you sure you want to delete the meal?")) {
      return meal.remove({
        _rev: meal._rev
      }).then(function() {
        $rootScope.$broadcast("mealdeleted", meal);
        return $location.path("/");
      });
    }
  };
});

;angular.module('emeals.controllers').controller('MealsListCtrl', function($scope, $routeParams, Meals, Navigation, Errors) {
  var loadMeals;
  $scope.$routeParams = $routeParams;
  $scope.nav = Navigation;
  $scope.search = {
    query: ''
  };
  loadMeals = function() {
    $scope.meals = Meals.search($scope.search.query);
    return $scope.meals.then(function(meals) {
      return $scope.meals = meals;
    });
  };
  loadMeals();
  $scope.$watch('search.query', loadMeals);
  $scope.$on("mealupdated", function(e, meal) {
    var existingMeal;
    existingMeal = _.find($scope.meals, {
      _id: meal._id
    });
    return _.extend(existingMeal, meal);
  });
  $scope.$on("mealdeleted", function(e, meal) {
    var index;
    index = _.findIndex($scope.meals, {
      _id: meal._id
    });
    return $scope.meals.splice(index, 1);
  });
  $scope.$on("fileuploaddone", function(e, data) {
    var failureCount, successCount;
    failureCount = data.result.failures.length;
    successCount = data.result.successes.length;
    if (failureCount > 0) {
      Errors.setWarning("" + successCount + " meals imported. " + failureCount + " failed to import.");
    } else {
      Errors.setSuccess("" + successCount + " meals imported.");
    }
    return loadMeals();
  });
  return $scope.$on("fileuploadfail", function(e, data) {
    return Errors.setError("An error occurred while importing. The error was logged.");
  });
});

;angular.module('emeals.controllers').controller('PlanEditCtrl', function($scope, plan, $location, Errors) {
  $scope.plan = plan;
  $scope.isNew = false;
  $scope.cancel = function() {
    return $location.path("/plans/" + plan._id);
  };
  return $scope.save = function() {
    return $scope.plan.put().then((function() {
      return $scope.cancel();
    }), Errors.defaultHandler);
  };
});

;angular.module('emeals.controllers').controller('PlanListCtrl', function($scope, pastPlans, futurePlans, current) {
  $scope.pastPlans = pastPlans;
  $scope.futurePlans = futurePlans;
  return $scope.current = current;
});

;angular.module('emeals.controllers').controller('PlanNewCtrl', function($scope, Dates, $location, Plans, Errors) {
  $scope.plan = {
    name: "",
    days: {
      start: Dates.today(),
      end: Dates.daysLater(6)
    },
    meals: {}
  };
  $scope.isNew = true;
  $scope.cancel = function() {
    return $location.path('/plans/current');
  };
  return $scope.save = function() {
    return Plans.create($scope.plan).then(function(result) {
      return $location.path("/plans/" + result.id);
    }, Errors.defaultHandler);
  };
});

;var mealCount;

mealCount = function(plan) {
  return _.flatten(_.values(plan.meals)).length;
};

angular.module('emeals.controllers').controller('PlanShowCtrl', function($scope, plan, Plans, $window, $location) {
  $scope.plan = plan;
  $scope.remove = function(day, index) {
    return $scope.plan.meals[day].splice(index, 1);
  };
  $scope.removePlan = function() {
    if ($window.confirm("Are you sure you want to delete the plan?")) {
      return $scope.plan.remove({
        _rev: $scope.plan._rev
      }).then(function() {
        return $location.path("/plans");
      });
    }
  };
  $scope.$watch('plan', function() {
    return $scope.groupedMealsByDay = _.groupBy(Plans.mealsByDay($scope.plan), function(value, index) {
      return Math.floor(index / 3);
    });
  });
  return $scope.$watch((function() {
    return mealCount($scope.plan);
  }), function(newValue, oldValue) {
    if (newValue !== oldValue) {
      return $scope.plan.put().then(function(result) {
        return $scope.plan._rev = result.rev;
      });
    }
  });
});

;angular.module('emeals.controllers').controller('ScheduledMealsCtrl', function($scope, Plans) {
  $scope.$watch('plan', function(plan) {
    return $scope.mealsByDay = Plans.mealsByDay(plan);
  });
  $scope.$watch('plan.days', (function() {
    return $scope.dayRange = Plans.rangeForDays($scope.plan);
  }), true);
  return $scope.isDayHidden = function(day) {
    return !_.contains($scope.dayRange, day);
  };
});

;var categories;

categories = {
  meat: "Meat and Seafood",
  "null": "Miscellaneous",
  packaged: "Canned and Packaged",
  produce: "Produce",
  refrigerated: "Refrigerated",
  staple: "Staples"
};

angular.module('emeals.controllers').controller('ShoppingListCtrl', function($scope, plan, shoppingList) {
  $scope.plan = plan;
  $scope.shoppingList = shoppingList.categories;
  return $scope.displayName = function(category) {
    return categories[category];
  };
});

;angular.module('emeals.directives').directive('draggable', function($location, Navigation) {
  return {
    restrict: 'A',
    link: function($scope, elem, attrs) {
      elem.draggable({
        helper: "clone",
        appendTo: "body",
        revert: true
      });
      return $scope.$watch((function() {
        return $location.path();
      }), function() {
        return elem.draggable("option", "disabled", !Navigation.isViewingPlans());
      });
    }
  };
});

;var getModelValue;

getModelValue = function(elem) {
  if (elem.attr('ng-model')) {
    return elem.scope().$eval(elem.attr('ng-model'));
  }
};

angular.module('emeals.directives').directive('droppable', function() {
  return {
    restrict: 'A',
    link: function($scope, elem, attrs) {
      return elem.droppable({
        hoverClass: "panel-success",
        drop: function(event, ui) {
          var draggedValue, droppedValue;
          droppedValue = getModelValue(elem);
          draggedValue = getModelValue(ui.draggable);
          if (droppedValue && draggedValue) {
            if (!_.contains(_.pluck(droppedValue, '_id'), draggedValue._id)) {
              if (!(attrs.droppableLimit && droppedValue.length >= attrs.droppableLimit)) {
                return $scope.$apply(function() {
                  return droppedValue.push(draggedValue);
                });
              }
            }
          }
        }
      });
    }
  };
});

;angular.module('emeals.directives').directive('keySave', function($parse) {
  return {
    restrict: 'A',
    link: function($scope, elem, attrs) {
      var doSave, fn;
      fn = $parse(attrs.keySave);
      doSave = function(e) {
        e.preventDefault();
        return $scope.$apply(function() {
          return fn($scope);
        });
      };
      elem.bind('keydown', 'meta+s', doSave);
      return elem.bind('keydown', 'ctrl+s', doSave);
    }
  };
});

;angular.module('emeals.directives').directive('let', function() {
  return {
    restrict: 'E',
    scope: true,
    link: function($scope, elem, attrs) {
      var assign;
      assign = function(value) {
        return $scope[attrs.name] = value;
      };
      assign($scope.$eval(attrs.value));
      return $scope.$watch(attrs.name, assign);
    }
  };
});

;angular.module('emeals.directives').directive('lineList', function() {
  return {
    scope: {
      text: '=text'
    },
    restrict: 'EA',
    template: '<li ng-repeat="line in lines">{{line}}</li>',
    replace: true,
    link: function($scope, elem, attrs) {
      var _ref;
      return $scope.lines = (_ref = $scope.text) != null ? _ref.split("\n") : void 0;
    }
  };
});

;angular.module('emeals.directives').directive('scrollToActive', function($timeout) {
  var isVisible, scrollToElement;
  isVisible = function(elem, container) {
    var element, viewport;
    viewport = {
      top: 0,
      bottom: container.height()
    };
    element = {
      top: elem.offset().top,
      bottom: elem.offset().top + elem.height()
    };
    return element.bottom <= viewport.bottom && element.top >= viewport.top;
  };
  scrollToElement = function(elem, container) {
    var elemTop, windowTop;
    windowTop = container.scrollTop();
    elemTop = elem.offset().top;
    if (elemTop < 0) {
      elemTop += windowTop - 70;
    } else {
      elemTop += windowTop - container.height() + elem.height() - 20;
    }
    return container.animate({
      scrollTop: elemTop
    });
  };
  return {
    restrict: 'A',
    link: function($scope, elem, attrs) {
      var container, scrollIfPossible;
      container = $(attrs.scrollContainer);
      scrollIfPossible = function(id) {
        var activeElem;
        activeElem = elem.find("[data-id=" + id + "]");
        if (activeElem.length > 0 && !isVisible(activeElem, container)) {
          return scrollToElement(activeElem, container);
        }
      };
      $scope.$watch(attrs.scrollToActive, scrollIfPossible);
      return $timeout(function() {
        return scrollIfPossible($scope.$eval(attrs.scrollToActive));
      }, 100);
    }
  };
});

;angular.module('emeals.directives').directive('uploadDropZone', function() {
  return {
    restrict: 'A',
    link: function($scope, elem) {
      var timeout;
      timeout = null;
      return $(document).bind('dragover', function(e) {
        var found, node;
        if (!timeout) {
          elem.addClass('in');
        } else {
          clearTimeout(timeout);
        }
        found = false;
        node = e.target;
        while (true) {
          if (node === elem[0]) {
            found = true;
            break;
          }
          node = node.parentNode;
          if (node === null) {
            break;
          }
        }
        if (found) {
          elem.addClass('hover');
        } else {
          elem.removeClass('hover');
        }
        return timeout = setTimeout(function() {
          timeout = null;
          return elem.removeClass('in hover');
        }, 100);
      });
    }
  };
});

;angular.module('emeals.filters').filter('capitalize', function() {
  return function(input) {
    return _.capitalize(input);
  };
});

;angular.module('emeals.filters').filter('ingredient', function() {
  return function(ingredient) {
    return "" + (ingredient.amount || '') + " " + (ingredient.unit || '') + " " + ingredient.description;
  };
});

;angular.module('emeals.filters').filter('utcdate', function($filter) {
  return function(input, format) {
    var localDate, localOffset, localTime;
    if (format == null) {
      format = 'mediumDate';
    }
    if (typeof input === "string") {
      localDate = new Date(input);
      localTime = localDate.getTime();
      localOffset = localDate.getTimezoneOffset() * 60000;
      return $filter('date')(new Date(localTime + localOffset), format);
    } else {
      return $filter('date')(input, format);
    }
  };
});

;angular.module('emeals.services').factory('Dates', function() {
  var Dates;
  return Dates = {
    format: function(date) {
      return date.toJSON().slice(0, 10);
    },
    toUTCDate: function(date) {
      var localOffset, localTime;
      localTime = date.getTime();
      localOffset = date.getTimezoneOffset() * 60000;
      return new Date(localTime - localOffset);
    },
    today: function() {
      return Dates.format(Dates.toUTCDate(new Date()));
    },
    daysLater: function(days) {
      var date;
      date = Dates.toUTCDate(new Date());
      date.setDate(date.getDate() + days);
      return Dates.format(date);
    }
  };
});

;angular.module('emeals.services').factory('Errors', function($rootScope) {
  var Errors;
  return Errors = {
    setError: function(message) {
      return Errors.setMessage('error', message);
    },
    setWarning: function(message) {
      return Errors.setMessage('warning', message);
    },
    setSuccess: function(message) {
      return Errors.setMessage('success', message);
    },
    setMessage: function(type, message) {
      return $rootScope.errors = [
        {
          type: type,
          message: message
        }
      ];
    },
    defaultHandler: function(result) {
      var _ref;
      return Errors.setError((result != null ? (_ref = result.data) != null ? _ref.reason : void 0 : void 0) || "An error occurred.");
    }
  };
});

;angular.module('emeals.services').factory('Meals', function(Restangular, $route) {
  var Meals;
  return Meals = {
    all: function() {
      return Restangular.all('meals').getList();
    },
    search: function(query) {
      if (query === '') {
        return Meals.all();
      } else {
        return Restangular.all('meals').customGETLIST('search', {
          q: query
        });
      }
    },
    load: function() {
      return Restangular.one('meals', $route.current.params.mealId).get();
    }
  };
});

;angular.module('emeals.services').factory('Navigation', function($location) {
  return {
    isViewingMeals: function() {
      return /^\/($|meals)/.test($location.path());
    },
    isViewingPlans: function() {
      return /^\/plans/.test($location.path());
    }
  };
});

;angular.module('emeals.services').factory('Plans', function(Dates, Restangular, $route) {
  var Plans;
  return Plans = {
    load: function(id) {
      if (id == null) {
        id = $route.current.params.id;
      }
      return Restangular.one('plans', id).get();
    },
    shoppingList: function(id) {
      if (id == null) {
        id = $route.current.params.id;
      }
      return Restangular.one('plans', id).customGET('shopping_list');
    },
    create: function(plan) {
      return Restangular.all('plans').post(plan);
    },
    past: function() {
      return Restangular.all('plans').customGETLIST('past');
    },
    future: function() {
      return Restangular.all('plans').customGETLIST('future');
    },
    rangeForDays: function(plan) {
      var currentDate, days, endDate;
      currentDate = new Date(plan.days.start);
      endDate = new Date(plan.days.end);
      days = [];
      while (currentDate <= endDate && days.length < 10) {
        days.push(currentDate);
        currentDate = new Date(currentDate);
        currentDate.setDate(currentDate.getDate() + 1);
      }
      return _.map(days, Dates.format);
    },
    mealsByDay: function(plan) {
      return _.map(Plans.rangeForDays(plan), function(day) {
        var _base;
        (_base = plan.meals)[day] || (_base[day] = []);
        return {
          day: day,
          meals: plan.meals[day]
        };
      });
    }
  };
});

;