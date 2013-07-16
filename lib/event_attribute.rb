# -*- encoding : utf-8 -*-
#
# Copyright (c) 2007 Jonathan Younger
# Copyright (c) 2013 Andrew Kuklewicz, Chris Rhoden
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
require 'active_record'

# EventAttribute allows you to turn your date/datetime columns in to boolean attributes.
# Idea for this was taken from http://jamis.jamisbuck.org/articles/2005/12/14/two-tips-for-working-with-databases-in-rails
#
#   class Referral < ActiveRecord::Base
#     event_attribute :applied_at, :attribute => 'pending', :nil_equals => true
#     event_attribute :subscribed_on
#   end
#
# Example:
#
#   referral = Referral.create(:applied_at => Time.now, :subscribed_on => nil)
#   referral.pending?           # => false
#   referral.subscribed?        # => false
# 
#   referral.pending = true
#   referral.applied_at         # => nil
#   referral.pending?           # => true
# 
#   referral.subscribed = true
#   referral.subscribed_at      # => Time.now
#   referral.subscribed?        # => true
#
# See EventAttribute::ClassMethods#event_attribute for configuration options

module EventAttribute #:nodoc:
  require 'event_attribute/version'

  extend ActiveSupport::Concern
  
  module ClassMethods
    # == Configuration options
    #
    # * <tt>attribute</tt> - name of the attribute that will be created in the model that returns true/false (default: column name minus '_at' or '_on')
    # * <tt>nil_equals</tt> - whether or not the attribute should return true or false if the column is nil (default: false)
    #
    def event_attribute(column, options = {})
      unless respond_to?(:event_attribute_attrs)
        class_attribute :event_attributes
        class_attribute :event_attribute_attrs
        self.event_attributes, self.event_attribute_attrs = {}, {}
      end
      
      attribute = (options[:attribute] || (column.to_s =~ /_at|_on/ ? column.to_s[0...-3] : raise("Unable to create default attribute name"))).to_sym
      
      nil_equals = options[:nil_equals] || false
      
      self.event_attribute_attrs[attribute] = column
      self.event_attributes[column] = nil_equals
      
      create_attribute_accessors(attribute, column, nil_equals)
    end
    
    private
    
    def create_attribute_accessors(attribute, column, nil_equals)
      define_method(attribute) { (nil_equals ? self[column].nil? : !self[column].nil?) }
      alias_method :"#{attribute.to_s}?", attribute
      
      # define the method to set the field value
      define_method(:"#{attribute.to_s}=") do |value|
        if [true, "1", 1, "t", "true"].include? value
          send("#{column}=", nil_equals ? nil : DateTime.now)
        elsif [false, "0", 0, "f", "false"].include? value
          send("#{column}=", nil_equals ? DateTime.now : nil)
        end
      end
    end

  end
end
ActiveRecord::Base.send :include, EventAttribute
