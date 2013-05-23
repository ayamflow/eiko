'use strict';

angular.module('myApp.directives')
.directive('equipe', ['$timeout', function($timeout) {
    return {
        link: function(scope, element, attr) {

            $timeout(init);

            function init() {
                var $divs = element.find('.block');

                scope.equipeTl = new TimelineMax();

                /*scope.equipeTl.add(TweenMax.from($divs.eq(0), 0.6, {position: 'relative', alpha: 0, right: -120, ease: Cubic.easeInOut}), 0);
                scope.equipeTl.add(TweenMax.from($divs.eq(1), 0.6, {position: 'relative', alpha: 0, left: -120, ease: Cubic.easeInOut}), 0.15);
                scope.equipeTl.add(TweenMax.from($divs.eq(2), 0.6, {position: 'relative', alpha: 0, right: -120, ease: Cubic.easeInOut}), 0.3);*/
                scope.equipeTl.add(TweenMax.from($divs.eq(2), 0.6, {position: 'relative', alpha: 0, top: -120, ease: Cubic.easeInOut}), 0);
                scope.equipeTl.add(TweenMax.from($divs.eq(1), 0.6, {position: 'relative', alpha: 0, top: -120, ease: Cubic.easeInOut}), 0.15);
                scope.equipeTl.add(TweenMax.from($divs.eq(0), 0.6, {position: 'relative', alpha: 0, top: -120, ease: Cubic.easeInOut}), 0.3);

                scope.equipeTl.gotoAndStop(0);
            }
        }
    };
}]);