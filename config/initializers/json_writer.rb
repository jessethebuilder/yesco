# Natively, Enumerators get JSONized like "#<Enumerator::Lazy:0x007f8714807080>", or they explode, either of which is a problem.
# We want them to make an array, and do it lazily so we don't have to keep the items in memory!
# class Enumerator
#   def to_json(state)
#     state.depth += 1
#
#     string = "[\n"
#     first_item = true
#
#     self.each do |item|
#       separator = ",\n" unless first_item
#
#       as_json = item.as_json
#
#       indentation = state.indent * state.depth
#       string << "#{separator}#{indentation}#{as_json.to_json(state)}"
#
#       first_item = false
#     end
#
#     state.depth -= 1
#
#     indentation = state.indent * state.depth
#     string << "\n#{indentation}]"
#   end
# end
