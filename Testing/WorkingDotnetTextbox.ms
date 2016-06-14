
FONTSTYLE = dotnetclass "System.Drawing.FontStyle"
TextBox = dotNetObject "System.Windows.Forms.TextBox"
TextBox.Location = dotNetObject "System.Drawing.Point" 3 10
TextBox.Width = 200
TextBox.Height = 12
TextBox.Visible = true
TextBox.MultiLine = false
TextBox.enabled = true
TextBox.ForeColor = (dotnetclass "System.Drawing.Color").FromArgb 20 20 20
TextBox.BackColor = (dotnetclass "System.Drawing.Color").FromArgb 120 120 120
TextBox.Text = "Viewport Display"
TextBox.Font = dotnetobject "System.Drawing.Font" "Arial" 8 FONTSTYLE.italic

-- Create Form
Form = dotNetObject "System.Windows.Forms.Form"
Form.Size = dotNetObject "System.Drawing.Size" 310 335
Form.Text = ".Net 2.0 Form with TextBox"
Form.Controls.Add(TextBox)
Form.TopMost = true
FormBorderStyle = dotNetClass "System.Windows.Forms.FormBorderStyle"
Form.FormBorderStyle = FormBorderStyle.FixedDialog
Form.ShowInTaskbar = false
Form.MinimizeBox = false
Form.MaximizeBox = false

-- Set appropriate Form background color
maxBackColor = colorMan.getColor #background
Form.BackColor = (dotnetclass "System.Drawing.Color").FromArgb 50 50 50

-- Show application Form
hApp = dotNetClass "System.Windows.Forms.Application"
hApp.Run Form