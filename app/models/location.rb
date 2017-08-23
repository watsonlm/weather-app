class Location < ApplicationRecord
	validates :city, :state, presence: true
	# validates :states, format: {with: /^[A-Z][A-Z]$/, message: 'Must use two letter postal abbreviation'}

end
