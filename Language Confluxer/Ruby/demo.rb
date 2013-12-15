#!/usr/bin/ruby
# coding: utf-8
#--------------------------------------------------------------------------
#  demo.rb
#  Blogdemos/Language Confluxer
#
#  Created by Egor Chiglintsev on December 14, 2013.
#  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
#--------------------------------------------------------------------------

# Add current directory to the search path
$: << "./"

require 'language'

confluxer = Language::Confluxer.new("PolishFemaleNames.txt")

1.upto(10) {|i| puts confluxer.next(rand 5..12)}