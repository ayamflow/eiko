'use strict';

angular.module('myApp.directives')
.directive('mouseParallax', ['$timeout', function($timeout) {
    return {
        link: function(scope, element, attr) {

            var $objects, number, baseWidth, baseHeight, coordinates;

            // $timeout(init);
            scope.$on('$home.ready', init);

            $(window).on('$destroy', destroy);

            function init() {
                $objects = element.find(attr['mouseParallax']);
                number = $objects.length;

                coordinates = [];
                for(var i=0; i < number; i++) {
                    coordinates.push({x: $objects.eq(i).offset().left, y: $objects.eq(i).offset().top, ratio: Math.random() * (20 - 10) + 10});
                }

                resize();

                $(window).bind('resize', resize);
                $(window).on('mousemove', onMove);
            }

            function onMove(e) {
                if($(window).scrollTop() >= baseHeight) return;

                var mx = e.clientX;
                var my = e.clientY;

                var dx = ((baseWidth >> 1) - mx);
                var dy = ((baseHeight >> 1) - my);

                // console.log('d:', dx, dy, 'm:', mx, my, 'base:', baseWidth, baseHeight);

                for(var i=0, shatter; i < number - 3; i++) {
                    shatter = coordinates[i];
                    TweenMax.to($objects.eq(i), 3, {left: shatter.x - dx * (shatter.x / (baseWidth >> 1) / shatter.ratio), top: shatter.y - dy * (shatter.y / (baseHeight >> 1) / shatter.ratio), ease: Cubic.easeOut});
                }
                for(i = number - 3; i < number; i++) {
                    shatter = coordinates[i];
                    // TweenMax.to($objects.eq(i), 0.2, {left: shatter.x + dx / 100});//, top: shatter.y + dy * (shatter.y / (baseHeight >> 1) / 15)});
                }
            }

            function resize() {
                baseWidth = window.innerWidth;
                baseHeight = window.innerHeight;
            }

            function destroy() {
                $(window).off('mousemove', onMove);
                $(window).off('resize', resize);
            }
        }
    };
}]);