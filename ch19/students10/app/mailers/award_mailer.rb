class AwardMailer < ApplicationMailer
	default from: "me@barnabasbulpett.com"

	def award_email(award)
			@award = award
			mail(to: 'Barnabas Bulpett <barnabasbulpett@example.com>',
					 subject: "Award from Learning Rails")
	end
end