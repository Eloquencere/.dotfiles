from gi.repository import Nautilus, GObject, Gtk, Gio
import os

class NewFileExtension(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        super().__init__()

    def get_background_items(self, *args):
        try:
            folder = args[1]
        except IndexError:
            folder = args[0]

        item = Nautilus.MenuItem(
            name="NewFileExtension::NewFile",
            label="New File...",
            tip="Create a new file"
        )
        item.connect("activate", self.create_file_dialog, folder)
        return [item]

    def create_file_dialog(self, menu, folder):
        # Create a standard dialog
        dialog = Gtk.Dialog(title="New File")
        dialog.add_button("Cancel", Gtk.ResponseType.CANCEL)
        
        # Create the OK button and style it as the 'suggested-action' (usually orange/blue)
        ok_button = dialog.add_button("Create", Gtk.ResponseType.OK)
        ok_button.get_style_context().add_class("suggested-action")
        
        # Set OK as the default so 'Enter' works
        dialog.set_default_response(Gtk.ResponseType.OK)

        # Create the input box
        entry = Gtk.Entry()
        entry.set_placeholder_text("File Name")
        entry.set_margin_top(20)
        entry.set_margin_bottom(20)
        entry.set_margin_start(20)
        entry.set_margin_end(20)
        
        # KEY FIX: This makes 'Enter' trigger the OK button
        entry.set_activates_default(True)
        
        content_area = dialog.get_content_area()
        content_area.append(entry)
        
        def on_response(dialog, response_id):
            if response_id == Gtk.ResponseType.OK:
                filename = entry.get_text().strip()
                if filename:
                    location = folder.get_location()
                    path = location.get_path()
                    full_path = os.path.join(path, filename)
                    # TODO: if the file extension is recognised display it's thumbnail to the left
                    try:
                        with open(full_path, 'x'):
                            pass
                    except FileExistsError:
                        print(f"File already exists") # TODO: print this on the dialogue box
            dialog.destroy()

        dialog.connect("response", on_response)
        dialog.present()
