#!/usr/bin/env python3
import json
import subprocess
import glob
import os

def color_t(t, bold=False):
    if t >= 80:
        c = "#ff7a93"
    elif t >= 65:
        c = "#ff9e64"
    else:
        c = "#b9f27c"
    b_open = "<b>" if bold else ""
    b_close = "</b>" if bold else ""
    return f"<span color=\"{c}\">{b_open}{t:4.1f}°C{b_close}</span>"

def generate_waybar_temp():
    try:
        res = subprocess.run(["sensors", "-j"], capture_output=True, text=True, timeout=2)
        sdata = json.loads(res.stdout) if res.returncode == 0 else {}
    except Exception:
        sdata = {}

    coretemp = {}
    for k, v in sdata.items():
        if "coretemp" in k:
            coretemp = v
            break

    pkg_temp = None
    cores = []
    if coretemp:
        for key, val in coretemp.items():
            if isinstance(val, dict):
                for subk, subv in val.items():
                    if "input" in subk:
                        if "Package" in key:
                            pkg_temp = float(subv)
                        elif "Core" in key:
                            cores.append((key, float(subv)))
    cores.sort(key=lambda x: x[0])

    nvme_temp = None
    for k, v in sdata.items():
        if "nvme" in k:
            comp = v.get("Composite", {})
            for subk, subv in comp.items():
                if "input" in subk:
                    nvme_temp = float(subv)

    wifi_temp = None
    for k, v in sdata.items():
        if "iwlwifi" in k or "wifi" in k:
            t1 = v.get("temp1", {})
            for subk, subv in t1.items():
                if "input" in subk:
                    wifi_temp = float(subv)

    acpi_temp = None
    for k, v in sdata.items():
        if "acpitz" in k:
            t1 = v.get("temp1", {})
            for subk, subv in t1.items():
                if "input" in subk:
                    acpi_temp = float(subv)

    sen_temps = []
    for tz in glob.glob("/sys/class/thermal/thermal_zone*"):
        try:
            with open(os.path.join(tz, "type")) as f:
                ttype = f.read().strip()
            with open(os.path.join(tz, "temp")) as f:
                tval = int(f.read().strip()) / 1000.0
            if ttype in ["SEN1", "SEN3", "SEN4"]:
                sen_temps.append((ttype, tval))
            if pkg_temp is None and ttype in ["x86_pkg_temp", "TCPU"]:
                pkg_temp = float(tval)
        except Exception:
            pass
    sen_temps.sort(key=lambda x: x[0])

    if pkg_temp is None:
        pkg_temp = 50.0

    lines = [
        "<tt><span color=\"#7da6ff\"><b>Component                 Temp</b></span>",
        "<span color=\"#505050\">──────────────────────────────</span>"
    ]
    lines.append(f"<b> CPU Package</b>           {color_t(pkg_temp, bold=True)}")
    for i, (cname, ctemp) in enumerate(cores):
        branch = "└─ " if i == len(cores) - 1 else "├─ "
        lines.append(f"{branch}{cname:<18}  {color_t(ctemp)}")
    
    if nvme_temp is not None:
        lines.append(f"<b>󰋊 NVMe SSD</b>              {color_t(nvme_temp, bold=True)}")
    if wifi_temp is not None:
        lines.append(f"<b>󰤨 Wi-Fi Card</b>            {color_t(wifi_temp, bold=True)}")
    if sen_temps:
        svals = [t[1] for t in sen_temps]
        smin, smax = min(svals), max(svals)
        lines.append(f"<b>󰌢 Motherboard</b>          <span color=\"#b9f27c\"><b>{smin:.0f}–{smax:.0f}°C</b></span>")
    if acpi_temp is not None:
        lines.append(f"<b> Ambient</b>               {color_t(acpi_temp)}")
    lines.append("</tt>")

    tooltip_text = "\n".join(lines)
    
    out = {
        "text": f"{int(round(pkg_temp))}°C 󰈸",
        "tooltip": tooltip_text,
        "class": "critical" if pkg_temp >= 82 else "normal"
    }
    return json.dumps(out)

if __name__ == "__main__":
    print(generate_waybar_temp())
