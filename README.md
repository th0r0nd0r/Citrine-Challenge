# README

Welcome to the home of the SI Unit converter!

The converter takes parameters from a query string, like so:

https://citrine-si-converter.herokuapp.com//units/si?units=degree/minute

It then serves up a JSON object containing two properties:

unit_name: a string with each incoming unit converted to its SI counterpart

multiplication_factor: a floating point number that converts your units to SI
