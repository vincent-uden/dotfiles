use anyhow::{Result, anyhow};
use std::io::Write;
use std::process::{Command, Stdio};

#[derive(Debug, Clone, PartialEq)]
pub struct Sink {
    pub name: String,
    pub description: String,
}

pub fn list_sinks() -> Result<Vec<Sink>> {
    let output = Command::new("pactl").args(["list", "sinks"]).output()?;

    if !output.status.success() {
        return Err(anyhow!(
            "pactl list sinks failed: {}",
            String::from_utf8_lossy(&output.stderr)
        ));
    }

    let output_str = String::from_utf8_lossy(&output.stdout);
    parse_sinks(&output_str)
}

fn parse_sinks(output: &str) -> Result<Vec<Sink>> {
    let mut sinks = Vec::new();
    let mut current_name: Option<String> = None;
    let mut current_description: Option<String> = None;

    for line in output.lines() {
        let trimmed = line.trim();

        // Sink names start with "Name: " (indented)
        if trimmed.starts_with("Name: ") {
            // Save previous sink if we have complete info
            if let (Some(name), Some(desc)) = (&current_name, &current_description) {
                sinks.push(Sink {
                    name: name.clone(),
                    description: desc.clone(),
                });
            }
            current_name = Some(trimmed.strip_prefix("Name: ").unwrap().to_string());
            current_description = None;
        }

        // Description follows the name
        if trimmed.starts_with("Description: ") {
            current_description = Some(trimmed.strip_prefix("Description: ").unwrap().to_string());
        }
    }

    // Don't forget the last sink
    if let (Some(name), Some(desc)) = (current_name, current_description) {
        sinks.push(Sink {
            name,
            description: desc,
        });
    }

    if sinks.is_empty() {
        return Err(anyhow!("No sinks found in pactl output"));
    }

    Ok(sinks)
}

pub fn set_default_sink(sink_name: &str) -> Result<()> {
    let output = Command::new("pactl")
        .args(["set-default-sink", sink_name])
        .output()?;

    if !output.status.success() {
        return Err(anyhow!(
            "Failed to set default sink: {}",
            String::from_utf8_lossy(&output.stderr)
        ));
    }

    Ok(())
}

pub fn cmd_audio_switcher() -> Result<()> {
    let sinks = list_sinks()?;

    let mut child = Command::new("wofi")
        .args(["-n", "--show", "dmenu", "-W", "700", "-H", "600", "-i"])
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()?;

    {
        let stdin = child.stdin.as_mut().unwrap();
        let mut input = String::new();
        for sink in &sinks {
            // Show description in wofi, but we'll need to map back to name
            input.push_str(&format!("{}\n", sink.description));
        }
        stdin.write_all(input.as_bytes())?;
    }

    let output = child.wait_with_output()?;
    let picked_description = String::from_utf8_lossy(&output.stdout);
    let picked_description = picked_description.trim();

    if let Some(sink) = sinks.iter().find(|s| s.description == picked_description) {
        set_default_sink(&sink.name)?;
        println!("Switched audio output to: {}", sink.description);
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_pactl_is_installed() {
        let result = Command::new("pactl").arg("--version").output();
        assert!(result.is_ok(), "pactl should be installed and executable");

        let output = result.unwrap();
        assert!(output.status.success(), "pactl --version should succeed");
    }

    #[test]
    fn test_list_sinks_returns_sinks() {
        let sinks = list_sinks().expect("Should be able to list sinks");
        assert!(
            sinks.len() >= 1,
            "Expected at least 1 sinks, found {}",
            sinks.len()
        );

        for sink in &sinks {
            assert!(!sink.name.is_empty(), "Sink name should not be empty");
            assert!(
                !sink.description.is_empty(),
                "Sink description should not be empty"
            );
        }
    }

    #[test]
    fn test_parse_sinks_with_sample_output() {
        let sample_output = r#"Sink 0
    State: RUNNING
    Name: alsa_output.pci-0000_00_1f.3.analog-stereo
    Description: Built-in Audio Analog Stereo
    Driver: module-alsa-card.c
    
Sink 1
    State: SUSPENDED
    Name: alsa_output.usb-Generic_USB_Audio-00.analog-stereo
    Description: USB Audio Analog Stereo
    Driver: module-alsa-card.c
    
Sink 2
    State: SUSPENDED
    Name: bluez_output.00_11_22_33_44_55.a2dp-sink
    Description: Bluetooth Headphones
    Driver: module-bluez5-device.c"#;

        let sinks = parse_sinks(sample_output).expect("Should parse sample output");
        assert_eq!(sinks.len(), 3, "Should find 3 sinks");

        assert_eq!(sinks[0].name, "alsa_output.pci-0000_00_1f.3.analog-stereo");
        assert_eq!(sinks[0].description, "Built-in Audio Analog Stereo");

        assert_eq!(
            sinks[1].name,
            "alsa_output.usb-Generic_USB_Audio-00.analog-stereo"
        );
        assert_eq!(sinks[1].description, "USB Audio Analog Stereo");

        assert_eq!(sinks[2].name, "bluez_output.00_11_22_33_44_55.a2dp-sink");
        assert_eq!(sinks[2].description, "Bluetooth Headphones");
    }

    #[test]
    fn test_parse_sinks_empty_input() {
        let result = parse_sinks("");
        assert!(result.is_err(), "Should error on empty input");
    }

    #[test]
    fn test_parse_sinks_no_descriptions() {
        let output = r#"Sink 0
    Name: sink1
    
Sink 1
    Name: sink2"#;

        let result = parse_sinks(output);
        assert!(result.is_err(), "Should error when sinks lack descriptions");
    }
}
