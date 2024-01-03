local gears     = require("gears")
local beautiful = require("beautiful")
local awful     = require("awful")

-- Function to update the shape of a client
local function update_client_shape(c)
    local current_tag = awful.screen.focused().selected_tag
    local clients_in_layout = current_tag:clients()

    local visible_clients = {}

    for _, client in ipairs(clients_in_layout) do
        if not client.minimized and client:isvisible() then
            table.insert(visible_clients, client)
        end
    end



    if c.minimized then
        c.shape = beautiful.client_shape_rectangle
    elseif not c.floating and #visible_clients > 1 then
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end
    elseif c.maximized or c.fullscreen then
        c.shape = beautiful.client_shape_rectangle
    elseif not c.round_corners then
        c.shape = beautiful.client_shape_rectangle
    else
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end
    end
end

-- Signals handling
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("manage", function(c)
    local current_tag = awful.screen.focused().selected_tag
    local clients_in_layout = current_tag:clients()
    -- Update the shape of the client
    local visible_clients = {}

    for _, client in ipairs(clients_in_layout) do
        if not client.minimized and client:isvisible() then
            table.insert(visible_clients, client)
        end
    end

    for _, c in ipairs(visible_clients) do
        update_client_shape(c)
    end
end)

client.connect_signal('property::fullscreen', function(c)
    if c.fullscreen then
        c.shape = beautiful.client_shape_rectangle
    else
        update_client_shape(c)
    end
end)

client.connect_signal('property::maximized', function(c)
    local current_layout = awful.tag.getproperty(c.first_tag, 'layout')
    if c.maximized then
        c.shape = beautiful.client_shape_rectangle
    else
        update_client_shape(c)
    end
end)

client.connect_signal('property::floating', function(c)
    local current_layout = awful.tag.getproperty(c.first_tag, 'layout')
    if c.floating and not c.maximized then
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end
    else
        if current_layout == awful.layout.suit.max then
            c.shape = beautiful.client_shape_rectangle
        else
            update_client_shape(c)
        end
    end
end)

client.connect_signal('unmanage', function(c)
    local current_tag = awful.screen.focused().selected_tag
    local clients_in_layout = current_tag:clients()
    -- Update the shape of the client
    local visible_clients = {}

    for _, client in ipairs(clients_in_layout) do
        if not client.minimized and client:isvisible() then
            table.insert(visible_clients, client)
        end
    end
    for _, remaining_client in ipairs(visible_clients) do
        update_client_shape(remaining_client)
    end
end)


client.connect_signal('property::minimized', function(c)
    local current_tag = awful.screen.focused().selected_tag
    local clients_in_layout = current_tag:clients()
    -- Update the shape of the client
    local visible_clients = {}

    for _, client in ipairs(clients_in_layout) do
        if not client.minimized and client:isvisible() then
            table.insert(visible_clients, client)
        end
    end
    for _, remaining_client in ipairs(visible_clients) do
        update_client_shape(remaining_client)
    end
end)
