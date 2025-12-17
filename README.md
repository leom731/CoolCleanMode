# CoolClean Mode

A macOS utility app that temporarily disables your keyboard and trackpad so you can safely clean them without accidentally typing or moving the cursor.

## Features

- **Blocks keyboard input** - All keyboard events are disabled while cleaning mode is active
- **Blocks trackpad input** - Trackpad clicks, gestures, and scrolling are disabled
- **Blocks mouse clicks** - All mouse clicks are disabled to prevent accidental actions
- **Keyboard shortcut to exit** - Press `⌃⌥⌘K` (Control + Option + Command + K) to exit cleaning mode
- **Cursor still moves** - You can see the cursor moving (helps verify the system is responsive)
- **Clean, simple UI** - Beautiful SwiftUI interface with clear visual feedback

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building)
- Accessibility permissions (the app will prompt you on first use)

## How to Build

1. Open the project in Xcode:
   ```bash
   open CoolCleanMode.xcodeproj
   ```

2. Select your development team in the project settings:
   - Click on the project in the navigator
   - Select the "CoolCleanMode" target
   - Go to "Signing & Capabilities"
   - Select your team from the dropdown

3. Build and run the app (⌘R)

## How to Use

1. **Launch the app** - Open CoolClean Mode when you're ready to clean your keyboard and trackpad

2. **Start cleaning mode** - Click the "Start Cleaning Mode" button

3. **Grant permissions** - On first use, macOS will ask for Accessibility permissions. Click "Open System Settings" and enable the permission for CoolClean Mode

4. **Clean safely** - Your keyboard, trackpad, and mouse clicks are now disabled! Clean them with a cloth or cleaning solution

5. **Stop cleaning mode** - When you're done, press `⌃⌥⌘K` (Control + Option + Command + K) on your keyboard

## Important Notes

### Accessibility Permissions
CoolClean Mode requires Accessibility permissions to intercept and block keyboard and trackpad events. When you first run the app, macOS will prompt you to grant these permissions. You can also manually enable them in:

**System Settings → Privacy & Security → Accessibility**

### Exit Method
The ONLY way to exit cleaning mode is by pressing `⌃⌥⌘K` (Control + Option + Command + K). This key combination was chosen because it requires all four modifier keys plus K, making it nearly impossible to press accidentally while cleaning.

### Cursor Movement
While all clicks are blocked, you can still see the cursor moving. This helps you verify that the system is still responsive during cleaning mode.

### Use Case
This app is designed for:
- Cleaning your MacBook keyboard and trackpad
- Wiping dust and debris from your input devices
- Cleaning with a damp cloth without triggering unwanted actions

### Not Running in Background
CoolClean Mode is designed to be launched only when you need to clean your devices. It doesn't need to run in the background or at startup.

## Technical Details

The app uses:
- **CGEvent API** - For intercepting and blocking system-level keyboard and trackpad events
- **SwiftUI** - For the user interface
- **Combine** - For state management
- **Accessibility APIs** - For event monitoring permissions

## Troubleshooting

**The app isn't blocking input:**
- Make sure you've granted Accessibility permissions in System Settings
- Try quitting and restarting the app
- Check that cleaning mode is actually activated (green indicator should be showing)

**I can't exit cleaning mode:**
- Press `⌃⌥⌘K` (Control + Option + Command + K) - hold all four modifier keys and press K
- If the keyboard isn't responding, force quit the app by holding the power button (macOS will automatically restore input when the app closes)

**I accidentally pressed something while cleaning:**
- Don't worry! All keyboard input is blocked, so no text will be typed
- All mouse and trackpad clicks are blocked, so no actions will occur
- Only cursor movement is allowed to show the system is responsive

## Version

Version 1.0

## License

Created for personal use. Feel free to modify and distribute as needed.
