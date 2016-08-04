require "rubygems"
require "ruby-libappindicator"
require "hue"

def add_submenu_activate(name:, parent:)
  sub_menu = Gtk::MenuItem.new name
  sub_menu.signal_connect "activate" do
    yield
  end
  parent.append sub_menu
end

ai = AppIndicator::AppIndicator.new("Hue Lights", "gtk-home", AppIndicator::Category::APPLICATION_STATUS);
root_menu = Gtk::Menu.new
client = Hue::Client.new

lights = client.lights

lights.each do |light|
  light_item = Gtk::MenuItem.new light.name
  light_actions = Gtk::Menu.new
  light_item.set_submenu light_actions

  add_submenu_activate name: "On", parent: light_actions do
    light.on!
  end

  add_submenu_activate name: "Off", parent: light_actions do
    light.off!
  end

  root_menu.append(light_item)
end

add_submenu_activate name: "exit", parent: root_menu do
  Gtk.main_quit
end

root_menu.show_all

ai.set_menu(root_menu)
ai.set_status(AppIndicator::Status::ACTIVE)

Gtk.main
