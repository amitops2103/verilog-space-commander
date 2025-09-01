# Verilog-Space-Comander
----------------------------------------------------

# Stellar Strike AI

**An intelligent Verilog-based fleet controller for the Makerchip ASIC Design Showdown 2025** 


https://github.com/user-attachments/assets/457d5ac1-64c4-4280-b916-6adb5570b11f

![video_middle_frame](https://github.com/user-attachments/assets/47c5ba39-1771-4ce1-959d-5ca4979da0e5)

## Rules of Combat

Your three ships can:

- accelerate
- fire up, down, left, or right
- activate a shield
- activate cloaking

Each ship has a recharging energy supply. Each action costs energy. You might take an offensive strategy, firing often; you might take a defensive strategy, leaning heavily on your shields and cloaking; or you might focus on maneuverability. Your strategy is what sets you apart from your competition.

Your ships are able to monitor the positions of the other ships (unless cloaked) and whether they are cloaked. They know which ships have been destroyed (on both teams). They cannot see enemy bullets or shields.

Ships are destroyed when they are shot or when their hit box exits the play area.

Control circuits have inputs characterizing the visible state of the system, and they provide outputs that affect this state on the next cycle. Acceleration is applied as an instantaneous burst that immediately affects velocity, which affects the position on the next cycle. The VIZ tab on a given cycle reflects the state as updated by the inputs on that cycle.

The coordinate system is flipped 180 degrees between the opponents, around (0, 0) in the center, so the starting ship coordinates are the same for both opponents. The X dimension increases to the right, and the Y dimension increases upward.

Ships are numbered 0, 1, 2 and have energy bars colored yellow, green, and blue, respectively. Players/teams are red and green, corresponding to 0 and 1 in the code, and, in VIZ, 1 and 2.

Other game parameters like hit box and board sizes can be found at the top of `showdown_lib.tlv`.

*Engineered to dominate space through logic, prediction, and precision.*

---

## 🚀 Overview
`stellar-strike-ai` is a TL-Verilog implementation of a 3-ship control strategy for the **Makerchip Space Battle** competition. It fuses predictive targeting, adaptive defense, and smart navigation into one powerful system.

### ⚔️ Core Features
- **🎯 Predictive Firing:** Fires where enemies will be using velocity estimation.
- **🛡️ Energy-Based Defense:** Cloaks and shields activate at mid-energy levels.
- **🧠 Boundary-Aware Movement:** Ships stay within the playfield using safe acceleration.
- **🕹️ Full Compatibility:** Works with `showdown_lib.tlv` and Makerchip’s VIZ tools.

---

## 🔧 Setup Instructions

### 1. Clone this repo
```bash
git clone https://github.com/YOUR_GITHUB_ID/stellar-strike-ai.git
cd stellar-strike-ai
```

### 2. Open in [Makerchip](https://makerchip.com/)
- Go to **Project > Connect File** and upload your `team_YOUR_GITHUB_ID.tlv`
- Simulate and visualize in real time.

---

## 🧠 Strategy Design

### Ship Roles
| Ship | Role         | Logic Summary                             |
|------|--------------|-------------------------------------------|
| 0    | Striker      | Aggressive predictive firing              |
| 1    | Defender     | Focuses on shields and cloaking           |
| 2    | Navigator    | Manages movement to avoid destruction     |

**Strategy Guide**
   └──> [Verilog_AI_Thinking_Guide.pdf](https://github.com/user-attachments/files/22082390/Verilog_AI_Thinking_Guide.pdf)
### Decision Flow
```

1. Is enemy visible and uncloaked?
   └──> Predict future position
         └──> Fire in direction of intercept
2. If energy is mid (20–40):
   └──> Activate shield + cloak
3. If energy is low (<=20):
   └──> Move away from borders (prevent destruction)
```

---

## 📂 File Structure
```bash
stellar-strike-ai/
├── team_YOUR_GITHUB_ID.sv     # Main TL-Verilog control logic
├── showdown_lib.tlv            # Game framework (included from upstream)
├── assets/
│   └── video_middle_frame      
│   └── Showdown_2025_-_Space_Battle_Preview
└── README.md
```

---

## 🤝 Contributing
If you'd like to fork, tune, or build on this logic:
1. Fork this repo
2. Create your own strategy
3. Test in Makerchip
4. Submit your version to the Showdown!

---

## 🏆 Credits
- Designed by **YOUR NAME / TEAM NAME**
- Developed for **The First Annual Makerchip ASIC Design Showdown, Summer 2025**
- Hosted by [Redwood EDA](https://www.redwoodeda.com/)

---

> “In space, logic is your strongest weapon.”
