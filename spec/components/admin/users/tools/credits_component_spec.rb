require "rails_helper"

RSpec.describe Admin::Users::Tools::CreditsComponent, type: :component do
  let(:user) { create(:user) }

  describe "Add user credits" do
    it "renders the section", :aggregate_failures do
      render_inline(described_class.new(user: user))

      expect(rendered_component).to have_text("available user credit".pluralize(user.unspent_credits_count))
      expect(rendered_component).to have_css("form[action=\"#{admin_user_tools_credits_path(user)}\"]")
    end
  end

  describe "Remove credits" do
    it "does not render the section by default" do
      render_inline(described_class.new(user: user))

      expect(rendered_component).not_to have_text("Remove credits")
    end

    it "renders the section if the user has unspent credits" do
      Credit.add_to(user, 1)

      render_inline(described_class.new(user: user))

      expect(rendered_component).to have_css("form[action=\"#{admin_user_tools_credits_path(user)}\"]")
    end
  end

  describe "Organization credits" do
    it "does not render the section by default", :aggregate_failures do
      render_inline(described_class.new(user: user))

      expect(rendered_component).not_to have_text("Add credits to organizations")
      expect(rendered_component).not_to have_text("Remove credits from organizations")
    end

    it "renders the section if the user belongs to an organization", :aggregate_failures do
      create(:organization_membership, user: user)

      render_inline(described_class.new(user: user))

      expect(rendered_component).to have_css('form[id="org_credits_add"]')
      expect(rendered_component).to have_css('form[id="org_credits_remove"]')
    end
  end
end