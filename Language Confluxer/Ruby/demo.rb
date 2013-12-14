#!/usr/bin/ruby
# coding: utf-8

# Add current directory to the search path
$: << "./"

require 'language'

confluxer = Language::Confluxer.new("PolishFemaleNames.txt")

1.upto(10) {|i| puts confluxer.next(rand 5..12)}