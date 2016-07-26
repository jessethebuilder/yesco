class Hal < ApplicationRecord
  serialize :saved_zips, Array
  # serialize :unsaved_zips, Array
end
