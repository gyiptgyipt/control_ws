# စက်ရုပ်များအတွက် ထိန်းချုပ်မှုအင်ဂျင်နီယာ အခြေခံများ

*စက်ရုပ်ထိန်းချုပ်မှုစနစ်များ တည်ဆောက်ရာတွင် အရေးပါသော အယူအဆများကို နားလည်ရန် လက်တွေ့လမ်းညွှန်။*

---

## မာတိကာ

1. [Transfer Function နှင့် Laplace Domain](#transfer-function-နှင့်-laplace-domain)
2. [Poles နှင့် Zeros](#poles-နှင့်-zeros)
3. [Integrator (1/s)](#integrator-1s)
4. [System Type နှင့် Steady-State Error](#system-type-နှင့်-steady-state-error)
5. [ပထမအဆင့်နှင့် ဒုတိယအဆင့် စနစ်များ](#ပထမအဆင့်နှင့်-ဒုတိယအဆင့်-စနစ်များ)
6. [တည်ငြိမ်မှုနှင့် Routh-Hurwitz](#တည်ငြိမ်မှုနှင့်-routh-hurwitz)
7. [Root Locus](#root-locus)
8. [Frequency Response နှင့် Bode Plot](#frequency-response-နှင့်-bode-plot)
9. [PID ထိန်းချုပ်မှု](#pid-ထိန်းချုပ်မှု)
10. [State-Space ကိုယ်စားပြုမှု](#state-space-ကိုယ်စားပြုမှု)
11. [စက်ရုပ်ဆိုင်ရာ အသုံးချမှုများ](#စက်ရုပ်ဆိုင်ရာ-အသုံးချမှုများ)
12. [အမြန်ကိုးကားဇယားများ](#အမြန်ကိုးကားဇယားများ)

---

## Transfer Function နှင့် Laplace Domain

### အဓိပ္ပာယ်
ကနဦးအခြေအနေများ သုညဖြစ်သော LTI စနစ်အတွက်:
$$G(s) = \frac{Y(s)}{U(s)} = \frac{\text{အထွက်}}{\text{အဝင်}}$$

### Laplace Transform ကို ဘာကြောင့်သုံးသလဲ?
- Differential equation များကို algebraic equation များအဖြစ် ပြောင်းပေးသည်။
- အချိန်ဒိုမိန်းရှိ convolution ကို s-domain ရှိ မြှောက်ခြင်းအဖြစ် ပြောင်းပေးသည်။
- တည်ငြိမ်မှု၊ ကြိမ်နှုန်းတုံ့ပြန်မှုနှင့် ယာယီတုံ့ပြန်မှုကို လေ့လာနိုင်စေသည်။

### အသုံးများသော Laplace အတွဲများ

| အချိန်ဒိုမိန်း | s-Domain |
|---|---|
| $\delta(t)$ (impulse) | $1$ |
| $1(t)$ (step) | $\frac{1}{s}$ |
| $t$ (ramp) | $\frac{1}{s^2}$ |
| $e^{-at}$ | $\frac{1}{s+a}$ |
| $t e^{-at}$ | $\frac{1}{(s+a)^2}$ |
| $\sin(\omega t)$ | $\frac{\omega}{s^2+\omega^2}$ |
| $\cos(\omega t)$ | $\frac{s}{s^2+\omega^2}$ |

### Block Diagram အက္ခရာသင်္ချာ

```
Series:       G1(s) → G2(s)     = G1(s)G2(s)
Parallel:     G1(s) + G2(s)     = G1(s)+G2(s)
Feedback:     G/(1+GH)          = Forward/(1+LoopGain)
```

---

## Poles နှင့် Zeros

### အဓိပ္ပာယ်ဖွင့်ဆိုချက်များ

| ဝေါဟာရ | အဓိပ္ပာယ် | ရုပ်ပိုင်းဆိုင်ရာ အဓိပ္ပာယ် |
|---|---|---|
| **Zeros** | အပေါ်ကိန်း၏ အမြစ်များ | အထွက် သုညဖြစ်စေသော ကြိမ်နှုန်းများ (ပိတ်ဆို့ခြင်း) |
| **Poles** | အောက်ကိန်း၏ အမြစ်များ | စနစ်၏ သဘာဝတုံ့ပြန်မှုပုံစံများ (resonance) |

### Pole-Zero Plot (S-Plane)

```
Imaginary (jω)
    ↑
    │     ×         ×        ← ရှုပ်ထွေးတွဲဖက် poles
    │    / \       / \
    │   /   \     /   \
    │  ×-----×---×-----×  ← Real axis (σ)
    │
    └──────────────────→ Real (σ)
         တည်ငြိမ်သောဒေသ: σ < 0
```

### Pole တည်နေရာနှင့် အချိန်တုံ့ပြန်မှု

| Pole တည်နေရာ | အချိန်တုံ့ပြန်မှု | တည်ငြိမ်မှု |
|---|---|---|
| အနုတ်ကိန်းစစ်: $s=-a$ | $e^{-at}$ (တဖြည်းဖြည်းလျော့ကျ) | တည်ငြိမ် |
| အပေါင်းကိန်းစစ်: $s=+a$ | $e^{+at}$ (တဖြည်းဖြည်းကြီးထွား) | **မတည်ငြိမ်** |
| စိတ်ကူးကိန်းစစ်: $s=\pm j\omega$ | $\sin(\omega t)$ (ဆက်လက်တုန်ခါ) | အနားသတ်တည်ငြိမ် |
| ရှုပ်ထွေးကိန်း: $s=-\sigma\pm j\omega_d$ | $e^{-\sigma t}\sin(\omega_d t)$ (လျော့ကျတုန်ခါ) | $\sigma>0$ ဖြစ်လျှင် တည်ငြိမ် |

### အဓိကဂုဏ်သတ္တိများ

1. **Poles** များက သဘာဝတုံ့ပြန်မှု (ယာယီတုံ့ပြန်မှု) ကို သတ်မှတ်သည်။
2. **Zeros** များက အတင်းဖြစ်ပေါ်သော တုံ့ပြန်မှု၏ အရွယ်အစားကို သက်ရောက်စေသည်။
3. **Dominant poles** (စိတ်ကူးဝင်ရိုးနှင့် အနီးဆုံး poles) များက စနစ်၏ အဓိကအပြုအမူကို ခန့်မှန်းပေးသည်။
4. **Minimum-phase မဟုတ်သော zeros** (ညာဘက်တစ်ဝက်ပြင်ညီရှိ zeros) များသည် အစပိုင်းတွင် မျှော်မှန်းချက်နှင့် ဆန့်ကျင်သော တုံ့ပြန်မှု ဖြစ်စေနိုင်သည်။

---

## Integrator (1/s)

### ဘာလဲ?
$$\frac{1}{s} \leftrightarrow \int_0^t u(\tau) d\tau$$

### စက်ရုပ်များတွင် အရေးကြီးပုံ

| အသုံးချမှု | အခန်းကဏ္ဍ |
|---|---|
| **အလျင်မှ တည်နေရာ** | $\theta = \int \omega dt$ |
| **အရှိန်မှ အလျင်** | $v = \int a dt$ |
| **PID ၏ Integral term** | Steady-state error ကို ဖယ်ရှားပေးသည်။ |
| **မော်တာဒိုင်နမစ်** | ဗို့အား → လျှပ်စီး → torque → အရှိန် → အလျင် → တည်နေရာ |

### Integrator ၏ ဂုဏ်သတ္တိများ

| ဂုဏ်သတ္တိ | ရှင်းလင်းချက် |
|---|---|
| **Pole at origin** | $s=0$ (အနားသတ်တည်ငြိမ်) |
| **Phase lag** | ကြိမ်နှုန်းအားလုံးတွင် -90° |
| **Gain slope** | -20 dB/decade |
| **Step response** | Ramp (အကန့်အသတ်မရှိ တိုးလာသည်) |
| **DC gain** | အနန္တ |

### Integrator ကို အကောင်အထည်ဖော်ခြင်း

#### ဆက်တိုက်အချိန် (Analog / Simulation)
```matlab
% Transfer function
G = tf(1, [1 0]);  % 1/s

% State space
A = 0; B = 1; C = 1; D = 0;  % dx/dt = u, y = x
```

#### ဒစ်ဂျစ်တယ်အကောင်အထည်ဖော်မှု

| နည်းလမ်း | ဖော်မြူလာ | အားသာချက်/အားနည်းချက် |
|---|---|---|
| **Forward Euler** | $y[k] = y[k-1] + T_s \cdot u[k-1]$ | ရိုးရှင်းသော်လည်း အချို့စနစ်များတွင် မတည်ငြိမ်နိုင်သည်။ |
| **Backward Euler** | $y[k] = y[k-1] + T_s \cdot u[k]$ | တည်ငြိမ်ပြီး implicit နည်းလမ်းဖြစ်သည်။ |
| **Trapezoidal (Tustin)** | $y[k] = y[k-1] + \frac{T_s}{2}(u[k]+u[k-1])$ | ကြိမ်နှုန်းကို ပိုမိုကောင်းမွန်စွာ ထိန်းသိမ်းပြီး စွမ်းအင်ကို ထိန်းညှိပေးသည်။ |

```python
# Python: Tustin နည်းဖြင့် ဒစ်ဂျစ်တယ် integrator
def integrator_tustin(u, Ts, y_prev=0, u_prev=0):
    y = y_prev + (Ts/2) * (u + u_prev)
    return y

# PID integral term (anti-windup)
def pid_integral(error, Ts, Ki, y_prev, saturated=False):
    if not saturated:  # Anti-windup: အထွက် saturation ဖြစ်လျှင် ဆက်လက်ပေါင်းခြင်းကို ရပ်ပါ
        y = y_prev + Ki * Ts * error
    else:
        y = y_prev
    return y
```

### Integrator Windup (အရေးကြီး!)

**ပြဿနာ**: အထွက် saturation ဖြစ်နေစဉ် integrator က error ကို ဆက်ပေါင်းနေပါက saturation ပြေလည်ချိန်တွင် အလွန်အကျွံ overshoot ဖြစ်နိုင်သည်။

**ဖြေရှင်းနည်းများ**:
1. **Back-calculation**: saturation မဖြစ်မီနှင့် ဖြစ်ပြီးနောက် အထွက်ကွာခြားချက်ကို ပြန်လည်ထည့်သွင်းသည်။
2. **Clamping**: အထွက် saturation ဖြစ်ချိန်တွင် integration ကို ရပ်သည်။
3. **Conditional integration**: error သေးငယ်ချိန် သို့မဟုတ် အထွက် saturation မဖြစ်ချိန်တွင်သာ ပေါင်းသည်။

```matlab
% Simulink PID block: "Anti-windup" → "Back-calculation" ကို ဖွင့်ပါ
% Kb (anti-windup gain) ≈ 1/Kp မှ 1/(10*Kp) အတွင်း သတ်မှတ်ပါ
```

---

## System Type နှင့် Steady-State Error

### System Type = Open-loop ထဲရှိ Integrator အရေအတွက်

| Type | Open-loop ပုံစံ | Step input | Ramp input | Parabolic input |
|---|---|---|---|---|
| **Type 0** | မူလနေရာတွင် pole မရှိ | $e_{ss}=\frac{1}{1+K_p}$ | ∞ | ∞ |
| **Type 1** | မူလနေရာတွင် pole တစ်ခု | **0** | $e_{ss}=\frac{1}{K_v}$ | ∞ |
| **Type 2** | မူလနေရာတွင် poles နှစ်ခု | **0** | **0** | $e_{ss}=\frac{1}{K_a}$ |

### Error Constant များ

| ကိန်းသေ | ဖော်မြူလာ | ရုပ်ပိုင်းဆိုင်ရာ အဓိပ္ပာယ် |
|---|---|---|
| $K_p$ (Position) | $\lim_{s\to0} G(s)$ | Step ကို လိုက်နိုင်သည့် တိကျမှု |
| $K_v$ (Velocity) | $\lim_{s\to0} sG(s)$ | Ramp ကို လိုက်နိုင်သည့် တိကျမှု |
| $K_a$ (Acceleration) | $\lim_{s\to0} s^2G(s)$ | Parabolic ကို လိုက်နိုင်သည့် တိကျမှု |

### စက်ရုပ်ဥပမာ: တည်နေရာထိန်းချုပ်မှု

```
မော်တာ: G(s) = 1/(s(s+2)(s+5)) → Type 1 (integrator တစ်ခု)
        └─ အလျင်မှ တည်နေရာရရန် integrator ပါဝင်သည်။

ထိန်းချုပ်ကိရိယာ: C(s) = Kp + Ki/s + Kd·s
Loop: L(s) = C(s)G(s)

ရလဒ်: Type 2 စနစ် (integrator နှစ်ခု) → အလျင်တည်ငြိမ်သော ramp အဝင်အတွက် steady-state error သုည
```

---

## ပထမအဆင့်နှင့် ဒုတိယအဆင့် စနစ်များ

### ပထမအဆင့်: $G(s) = \frac{K}{\tau s + 1}$

| တိုင်းတာချက် | ဖော်မြူလာ | တန်ဖိုး/အဓိပ္ပာယ် |
|---|---|---|
| **Time constant** | $\tau$ | တုံ့ပြန်မှု၏ 63.2% သို့ ရောက်ချိန် |
| **Settling (2%)** | $4\tau$ | 2% အတွင်းတွင် ဆက်လက်တည်ရှိရန် ကြာချိန် |
| **Settling (5%)** | $3\tau$ | 5% အတွင်းတွင် ဆက်လက်တည်ရှိရန် ကြာချိန် |
| **Bandwidth** | $\omega_{bw}=1/\tau$ | -3 dB ကြိမ်နှုန်း |
| **Pole** | $s=-1/\tau$ | အနုတ်ကိန်းစစ် pole |

### ဒုတိယအဆင့်: $G(s) = \frac{K\omega_n^2}{s^2 + 2\zeta\omega_n s + \omega_n^2}$

| ပါရာမီတာ | သင်္ကေတ | အဓိပ္ပာယ် |
|---|---|---|
| သဘာဝကြိမ်နှုန်း | $\omega_n$ | damping မပါလျှင် ဖြစ်မည့် တုန်ခါကြိမ်နှုန်း |
| Damping ratio | $\zeta$ | တုံ့ပြန်မှုပုံစံကို သတ်မှတ်သည်။ |

#### Damping ဒေသများ

| $\zeta$ | အမျိုးအစား | Poles | Overshoot |
|---|---|---|---|
| $\zeta>1$ | Overdamped | မတူညီသော အမှန် poles နှစ်ခု | 0% |
| $\zeta=1$ | Critically damped | ထပ်နေသော အမှန် poles နှစ်ခု | 0% |
| $0<\zeta<1$ | Underdamped | ရှုပ်ထွေးတွဲဖက် poles | $e^{-\zeta\pi/\sqrt{1-\zeta^2}}$ |
| $\zeta=0$ | Undamped | စိတ်ကူးကိန်းစစ် $\pm j\omega_n$ | 100% (တုန်ခါမှုမလျော့) |
| $\zeta<0$ | မတည်ငြိမ် | ညာဘက်တစ်ဝက် ရှုပ်ထွေး poles | ကြီးထွားလာသည်။ |

#### စွမ်းဆောင်ရည်တိုင်းတာချက်များ (Underdamped, $0<\zeta<1$)

| တိုင်းတာချက် | ဖော်မြူလာ |
|---|---|
| **Peak time** | $t_p = \frac{\pi}{\omega_n\sqrt{1-\zeta^2}}$ |
| **% Overshoot** | $\%OS = 100 e^{-\zeta\pi/\sqrt{1-\zeta^2}}$ |
| **Settling (2%)** | $t_s \approx \frac{4}{\zeta\omega_n}$ |
| **Rise time (10-90%)** | $t_r \approx \frac{1.8}{\omega_n}$ ($\zeta \approx 0.5$ အတွက်) |
| **Damped frequency** | $\omega_d = \omega_n\sqrt{1-\zeta^2}$ |

#### စက်ရုပ်ဒီဇိုင်းအတွက် ပစ်မှတ်များ

| အသုံးချမှု | ပစ်မှတ် $\zeta$ | ပစ်မှတ် $\omega_n$ | ရည်ရွယ်ချက် |
|---|---|---|---|
| **Joint position** | 0.7 - 1.0 | 10 - 50 rad/s | Overshoot နည်းပြီး settling မြန်ရန် |
| **Force control** | 0.5 - 0.7 | 5 - 20 rad/s | လိုက်လျောညီထွေမှုနှင့် အနှောင့်အယှက်ပယ်ဖျက်မှု |
| **Trajectory tracking** | 0.7 - 0.9 | 5 - 30 rad/s | မြန်နှုန်းနှင့် overshoot ကို မျှတစေရန် |
| **Balancing robot** | 0.3 - 0.5 | 2 - 10 rad/s | တုံ့ပြန်မှုမြန်ရန်၊ အနည်းငယ်တုန်ခါမှု လက်ခံနိုင်သည်။ |

---

## တည်ငြိမ်မှုနှင့် Routh-Hurwitz

### တည်ငြိမ်မှုစံ
Pole အားလုံး၏ **အမှန်ပိုင်းတန်ဖိုးများ အနုတ်** ဖြစ်ရမည် (ဘယ်ဘက်တစ်ဝက်ပြင်ညီ၊ LHP)။

### Routh-Hurwitz စမ်းသပ်နည်း

Characteristic polynomial: $a_n s^n + a_{n-1}s^{n-1} + ... + a_0 = 0$

1. Coefficient အားလုံး $a_i>0$ ဖြစ်ရမည် (လိုအပ်ချက်ဖြစ်သော်လည်း လုံလောက်ချက် မဟုတ်ပါ)။
2. Routh array ကို တည်ဆောက်ပါ:
```
s^n:    a_n      a_{n-2}  a_{n-4} ...
s^{n-1}: a_{n-1}  a_{n-3}  a_{n-5} ...
s^{n-2}: b_1      b_2      b_3 ...
s^{n-3}: c_1      c_2      c_3 ...
...
s^0:    ...
```
   ဥပမာ $b_1 = \frac{a_{n-1}a_{n-2} - a_n a_{n-3}}{a_{n-1}}$ ဖြစ်သည်။
3. ပထမကော်လံရှိ တန်ဖိုးအားလုံး သုညထက်ကြီးမှသာ **တည်ငြိမ်** သည်။

### ဥပမာ: $s^3 + 7s^2 + 10s + K = 0$

```
s^3:  1       10
s^2:  7       K
s^1:  (70-K)/7 0
s^0:  K
```

တည်ငြိမ်ရန် $K>0$ နှင့် $(70-K)/7>0$ ဖြစ်ရမည်။ ထို့ကြောင့် **$0<K<70$** ဖြစ်သည်။

---

## Root Locus

### ဘာကိုပြသသလဲ?
Gain $K$ ကို 0 မှ အနန္တအထိ ပြောင်းလဲသောအခါ closed-loop poles များ ရွေ့လျားပုံကို ပြသည်။

### တည်ဆောက်ပုံ စည်းမျဉ်းများ

| စည်းမျဉ်း | ရှင်းလင်းချက် |
|---|---|
| 1. Branches | Branch အရေအတွက် $n$ ခု ($n$ = poles အရေအတွက်) |
| 2. အစ/အဆုံး | $K=0$ တွင် poles မှ စတင်ပြီး $K=\infty$ တွင် zeros သို့ ရောက်သည်။ |
| 3. Real axis | ညာဘက်တွင် poles နှင့် zeros စုစုပေါင်း မကိန်းရှိသော အပိုင်းများတွင် locus ရှိသည်။ |
| 4. Asymptotes | $n-m$ branch များသည် asymptote များအတိုင်း အနန္တသို့ သွားသည်။ |
| 5. Breakaway | Real axis ပေါ်တွင် $dK/ds=0$ ဖြစ်သည့်နေရာများ |
| 6. $j\omega$ ဖြတ်ကူးမှု | စိတ်ကူးဝင်ရိုးကို pole ဖြတ်သည့် $K$ ကို Routh-Hurwitz ဖြင့် ရှာပါ။ |

### Asymptote များ

| ဂုဏ်သတ္တိ | ဖော်မြူလာ |
|---|---|
| Centroid | $\sigma_a = \frac{\sum\text{poles} - \sum\text{zeros}}{n-m}$ |
| ထောင့်များ | $\theta_a = \frac{(2k+1)180°}{n-m}$, $k=0,1,...,n-m-1$ |

### စက်ရုပ်ဆိုင်ရာ အသုံးချမှု

```
K ကိုရွေးရာတွင်:
- လိုချင်သော damping ($ζ ≈ 0.7$ → 45° မျဉ်း)
- လိုချင်သော တုံ့ပြန်မြန်နှုန်း (မူလမှ $ω_n$ အကွာအဝေး)
- တည်ငြိမ်မှုအနားသတ် (jω ဝင်ရိုးမှ အကွာအဝေး)
```

---

## Frequency Response နှင့် Bode Plot

### Bode Plot တွင် ဂရပ်နှစ်ခုပါသည်

| ဂရပ် | Y ဝင်ရိုး | X ဝင်ရိုး | အဓိကသိနိုင်သောအချက် |
|---|---|---|---|
| **Magnitude** | $20\log_{10}|G(j\omega)|$ (dB) | $\log_{10}\omega$ | Gain၊ bandwidth၊ slope |
| **Phase** | $\angle G(j\omega)$ (deg) | $\log_{10}\omega$ | Phase lag၊ delay |

### Asymptotic ခန့်မှန်းချက်များ

| Term | Corner frequency | Magnitude slope | Phase |
|---|---|---|---|
| $K$ | - | 0 dB/dec | 0° |
| $\frac{1}{s}$ | - | -20 dB/dec | -90° |
| $s$ | - | +20 dB/dec | +90° |
| $\frac{1}{\tau s+1}$ | $1/\tau$ | နောက်ပိုင်း -20 dB/dec | နောက်ပိုင်း -90° |
| $\tau s+1$ | $1/\tau$ | နောက်ပိုင်း +20 dB/dec | နောက်ပိုင်း +90° |
| $\frac{\omega_n^2}{s^2+2\zeta\omega_n s+\omega_n^2}$ | $\omega_n$ | နောက်ပိုင်း -40 dB/dec | နောက်ပိုင်း -180° |

### တည်ငြိမ်မှုအနားသတ်များ

| အနားသတ် | အဓိပ္ပာယ် | ပစ်မှတ် |
|---|---|---|
| **Gain Margin (GM)** | Phase = -180° ဖြစ်ချိန် $1/|G(j\omega_{180})|$ | ≥ 6 dB (2 ဆ) |
| **Phase Margin (PM)** | $|G|=1$ ဖြစ်ချိန် $180°+\angle G(j\omega_0)$ | ≥ 30° (ခိုင်ခံ့), ≥ 45° (ကောင်း), ≥ 60° (အလွန်ခိုင်ခံ့) |

### Crossover Frequency များ

| ကြိမ်နှုန်း | အဓိပ္ပာယ် |
|---|---|
| $\omega_{gc}$ (gain crossover) | $|G(j\omega)|=1$ (0 dB) ဖြစ်သည့် ကြိမ်နှုန်း |
| $\omega_{pc}$ (phase crossover) | $\angle G(j\omega)=-180°$ ဖြစ်သည့် ကြိမ်နှုန်း |

### Bandwidth
- Closed-loop -3 dB ကြိမ်နှုန်းဖြစ်သည်။
- $\omega_{bw} \approx 1.5/\tau_r$ (rise time $\tau_r$)။
- Bandwidth မြင့်လျှင် တုံ့ပြန်မှုမြန်သော်လည်း noise ကို ပိုမိုခံစားလွယ်သည်။

---

## PID ထိန်းချုပ်မှု

### ဆက်တိုက်ပုံစံ
$$C(s) = K_p + \frac{K_i}{s} + K_d s = K_p\left(1 + \frac{1}{T_i s} + T_d s\right)$$

### Term တစ်ခုစီ၏ သက်ရောက်မှု

| Term | အချိန်ဒိုမိန်း | ကြိမ်နှုန်းဒိုမိန်း | သက်ရောက်မှု |
|---|---|---|---|
| **P** | $K_p e(t)$ | $K_p$ | ချက်ချင်းတုံ့ပြန်ပြီး rise time ကို လျှော့ပေးသည်။ |
| **I** | $K_i \int e dt$ | $\frac{K_i}{j\omega}$ | Steady-state error ကို ဖယ်ရှားပြီး phase -90° ထပ်လျော့စေသည်။ |
| **D** | $K_d \frac{de}{dt}$ | $K_d j\omega$ | အနာဂတ် error ကို ခန့်မှန်းကာ phase +90° သက်ရောက်စေသည်။ |

### Tuning နည်းလမ်းများ

| နည်းလမ်း | အသုံးပြုရန် | အဆင့်များ |
|---|---|---|
| **Z-N Step Response** | FOPDT model | $K_p=1.2\tau/(KL)$, $K_i=K_p/(2L)$, $K_d=0.5K_pL$ |
| **Z-N Ultimate Gain** | စနစ်ကို တုန်ခါစေနိုင်လျှင် | $K_u,T_u$ ရှာပါ; $K_p=0.6K_u$, $K_i=1.2K_u/T_u$, $K_d=0.075K_uT_u$ |
| **Cohen-Coon** | Dead time ကြီးလျှင် | Disturbance rejection ပိုကောင်းစေရန် ပြုပြင်ထားသော Z-N |
| **PID Tuner (MATLAB)** | မည်သည့် model မဆို | အပြန်အလှန်ညှိနိုင်ပြီး လိုအပ်ချက်များအကြား အပေးအယူရွေးနိုင်သည်။ |

### စက်ရုပ်များအတွက် လက်တွေ့ PID

```matlab
% စက်ရုပ် joint PID ဖွဲ့စည်းပုံ
% Plant: Motor + gearbox + link = 1/(s(Js+b)(Ls+R)+K^2)
% ရိုးရှင်းသတ်မှတ်လျှင်: 1/(s*(s+a)*(s+b))

% Filter ပါသော ပုံမှန်ပုံစံ
C(s) = Kp*(1 + 1/(Ti*s) + Td*s/(1+Td/N*s))

% ပုံမှန် N (filter coefficient) = 10-100
% Anti-windup: Kb = 1/Kp မှ 1/(10*Kp) ဖြင့် back-calculation
```

### ဒစ်ဂျစ်တယ် PID အကောင်အထည်ဖော်မှု

```python
# Discrete PID (Tustin/Trapezoidal)
class DiscretePID:
    def __init__(self, Kp, Ki, Kd, Ts, N=100):
        self.Kp, self.Ki, self.Kd, self.Ts, self.N = Kp, Ki, Kd, Ts, N
        self.integral = 0
        self.prev_error = 0
        self.prev_derivative = 0

    def update(self, error, output_limits=(-1, 1)):
        # Proportional
        P = self.Kp * error

        # Anti-windup ပါသော trapezoidal integral
        self.integral += self.Ki * self.Ts * (error + self.prev_error) / 2
        # Anti-windup: အထွက် saturation ကို သိရှိပုံအလိုက် integral ကို ကန့်သတ်ပါ

        # Filter လုပ်ထားသော derivative
        derivative = self.Kd * self.N * (error - self.prev_error) / (1 + self.N * self.Ts/2)

        output = P + self.integral + derivative

        self.prev_error = error
        return np.clip(output, *output_limits)
```

---

## State-Space ကိုယ်စားပြုမှု

### ဆက်တိုက်ပုံစံ
$$\dot{x} = Ax + Bu$$
$$y = Cx + Du$$

| သင်္ကေတ | အရွယ်အစား | အဓိပ္ပာယ် |
|---|---|---|
| $x$ | $n \times 1$ | State vector |
| $u$ | $m \times 1$ | Input vector |
| $y$ | $p \times 1$ | Output vector |
| $A$ | $n \times n$ | စနစ်ဒိုင်နမစ် |
| $B$ | $n \times m$ | အဝင်သက်ရောက်ပုံ |
| $C$ | $p \times n$ | အထွက်တိုင်းတာပုံ |
| $D$ | $p \times m$ | တိုက်ရိုက်အဝင်မှအထွက် လမ်းကြောင်း |

### Canonical Form များ

| Form | A Matrix | အသုံးပြုပုံ |
|---|---|---|
| **Controllable** | Companion | ထိန်းချုပ်ကိရိယာဒီဇိုင်း |
| **Observable** | Companionᵀ | Observer ဒီဇိုင်း |
| **Modal** | Diagonal (poles မတူလျှင်) | Modal analysis |
| **Balanced** | $\Sigma=\Sigma_c=\Sigma_o$ | Model လျှော့ချခြင်း |

### Transfer Function မှ State Space သို့

```matlab
% MATLAB
sys_tf = tf([1], [1, 7, 10, 0]);  % 1/(s^3+7s^2+10s)
sys_ss = ss(sys_tf);  % Controllable canonical form

% Controllability/observability ကို စစ်ဆေးပါ
ctrb = rank(ctrb(sys_ss.A, sys_ss.B));
obsv = rank(obsv(sys_ss.A, sys_ss.C));
```

### State Feedback Control (Pole Placement)

```matlab
% လိုချင်သော closed-loop poles
p_desired = [-2, -3, -4];

% Gain K ကို တွက်ပါ (Ackermann's formula)
K = place(A, B, p_desired);  % သို့မဟုတ် K = acker(A, B, p_desired)

% Closed-loop စနစ်
A_cl = A - B*K;
```

### Observer ဒီဇိုင်း (State ခန့်မှန်းခြင်း)

```matlab
% Full-order observer (Luenberger)
% Observer poles ကို controller poles ထက် 2-5 ဆ ပိုမြန်စွာရွေးပါ
p_obs = 3 * p_desired;
L = place(A', C', p_obs)';  % Pole placement ၏ dual ပုံစံ

% Kalman filter (အကောင်းဆုံး observer)
[L, P, E] = kalman(sys_ss, Qn, Rn);  % Qn=process noise, Rn=measurement noise
```

---

## စက်ရုပ်ဆိုင်ရာ အသုံးချမှုများ

### 1. Motor + Gearbox + Link ဒိုင်နမစ်

```
Voltage → Current → Torque → Acceleration → Velocity → Position
   V       i = (V-Kv)/R    τ = Kt*i      α = τ/J       ω = ∫α dt      θ = ∫ω dt

Transfer function (V → θ):
G(s) = K / [s (Js+b) (Ls+R) + Kt*Ke]
     ≈ K / [s (τ_m s+1) (τ_e s+1)]  (mechanical နှင့် electrical time constants)
```

### 2. စက်ရုပ်ထိန်းချုပ်မှု တည်ဆောက်ပုံများ

| တည်ဆောက်ပုံ | ဖော်မြူလာ | အသုံးပြုပုံ |
|---|---|---|
| **Computed Torque** | $\tau=M(q)\ddot{q}_d+C(q,\dot{q})\dot{q}_d+g(q)+K_p e+K_d\dot{e}$ | Model အခြေပြု၊ စွမ်းဆောင်ရည်မြင့် |
| **PD + Gravity Comp** | $\tau=g(q)+K_p e+K_d\dot{e}$ | ပိုရိုးရှင်း၊ နှေးသောလှုပ်ရှားမှုအတွက် သင့်တော် |
| **Impedance Control** | $M_d\ddot{x}+B_d\dot{x}+K_d x=F_{ext}$ | အပြန်အလှန်ထိတွေ့မှု၊ force control |
| **Admittance Control** | $\ddot{x}=M^{-1}(F_{ext}-B\dot{x}-Kx)$ | လူနှင့်စက်ရုပ် အပြန်အလှန်ဆက်သွယ်မှု |

### 3. အဆင့်ဆင့်ချိတ်ဆက်ထားသော Control Loop များ

```
┌─────────────────────────────────────────────────────┐
│ Position Loop (အပြင်ဘက်, ~100-500 Hz)              │
│   တည်နေရာ error အပေါ် PD သို့မဟုတ် PID              │
│   အထွက်: velocity command                           │
│   └──────────────────────────────────────────────┐  │
│   Velocity Loop (အလယ်, ~1-2 kHz)                  │  │
│     အလျင် error အပေါ် PI                            │  │
│     အထွက်: current/torque command                  │  │
│     └────────────────────────────────────────┐   │  │
│     Current Loop (အတွင်းဘက်, ~10-20 kHz)      │   │  │
│       လျှပ်စီး error အပေါ် PI                    │   │  │
│       အထွက်: PWM voltage                       │   │  │
│       └────────────────────────────────────┐  │   │  │
│       Motor + Driver + Encoder              │  │   │  │
└─────────────────────────────────────────────────────┘
```

### 4. ပုံမှန် Bandwidth အဆင့်ဆင့်

| Loop | Bandwidth | Update rate | Controller |
|---|---|---|---|
| Current | 1-5 kHz | 10-20 kHz | PI |
| Velocity | 200-500 Hz | 1-2 kHz | PI |
| Position | 50-200 Hz | 500-1000 Hz | PD/PID |

---

## အမြန်ကိုးကားဇယားများ

### စက်ရုပ်များတွင် တွေ့ရလေ့ရှိသော Transfer Function များ

| အစိတ်အပိုင်း | Transfer function | မှတ်ချက် |
|---|---|---|
| DC Motor (V→ω) | $\frac{K}{(Js+b)(Ls+R)+K^2}$ | Position အတွက် ထပ်ပေါင်း integrator ပါလျှင် 2nd order + integrator |
| DC Motor (V→θ) | $\frac{K}{s[(Js+b)(Ls+R)+K^2]}$ | 3rd order |
| Gearbox | $\frac{1}{N}$ (ideal) | Ratio $N:1$ |
| Flexible joint | $\frac{K}{s^2(J_m s^2+b_m s+k)(J_l s^2+b_l s)+k}$ | 4th order နှင့်အထက် |
| PID | $K_p+K_i/s+K_d s$ | D အတွက် filter ထည့်ပါ: $K_d s/(1+\tau_f s)$ |
| Lead comp | $K \frac{s+z}{s+p}, z<p$ | Phase ကို ရှေ့တိုးစေသည်။ |
| Lag comp | $K \frac{s+z}{s+p}, z>p$ | ကြိမ်နှုန်းနိမ့် gain ကို မြှင့်သည်။ |

### အသုံးဝင်သော MATLAB/Python Command များ

```matlab
% Analysis
tf(num, den)            % Transfer function ဖန်တီးရန်
ss(A,B,C,D)             % State-space ဖန်တီးရန်
tf2ss, ss2tf            % ပြောင်းလဲရန်
pole(sys), zero(sys)    % Poles/zeros
step(sys), impulse(sys) % အချိန်တုံ့ပြန်မှု
bode(sys), nyquist(sys) % ကြိမ်နှုန်းတုံ့ပြန်မှု
margin(sys)             % GM, PM
rlocus(sys)             % Root locus
pidtune(sys, 'PID')     % PID အလိုအလျောက်ညှိရန်
place(A,B,p)            % Pole placement
acker(A,B,p)            % Ackermann နည်း
ctrb, obsv              % Controllability/observability
kalman(sys, Q, R)       % Kalman filter
```

```python
# Python (control library)
import control as ctrl
ctrl.tf(num, den)
ctrl.ss(A, B, C, D)
ctrl.pole(sys), ctrl.zero(sys)
ctrl.step_response(sys)
ctrl.bode(sys)
ctrl.margin(sys)
ctrl.root_locus(sys)
ctrl.pid_tune(sys, 'PID')
ctrl.place(A, B, p)
ctrl.ctrb(A, B), ctrl.obsv(A, C)
```

### တည်ငြိမ်မှု အမြန်စစ်ဆေးချက်

| စမ်းသပ်ချက် | အောင်မြင်ရန် လိုအပ်ချက် |
|---|---|
| Coefficient အားလုံး > 0 | လိုအပ်ချက် |
| Routh array ပထမကော်လံ > 0 | လုံလောက်သော စံ |
| Nyquist: -1 ကို ပတ်ဝန်းကျင်မလှည့် | $P=0$ ဖြစ်လျှင် တည်ငြိမ် |
| Bode: GM > 0 dB, PM > 0° | တည်ငြိမ် |
| Root locus: poles အားလုံး LHP | တည်ငြိမ် |

---

## စက်ရုပ်ထိန်းချုပ်မှုအတွက် အဓိကမှတ်သားရန်

1. **Integrator များကို နေရာတိုင်းတွင် တွေ့ရသည်** (အလျင်မှ တည်နေရာ၊ PID integral)။
2. **System type က steady-state error ကို သတ်မှတ်သည်**။ Error သုညလိုပါက integrator ထည့်သွင်းနိုင်သည်။
3. **ဒုတိယအဆင့်ခန့်မှန်းပုံစံ** သည် joint controller အများစုအတွက် အသုံးဝင်သည်။
4. **အဆင့်ဆင့် control loop များ** ဖြင့် bandwidth ကို ခွဲထားနိုင်သည်: current > velocity > position။
5. **ဒစ်ဂျစ်တယ်အကောင်အထည်ဖော်မှုက အရေးကြီးသည်**: Tustin၊ anti-windup နှင့် သင့်လျော်သော sampling ကို သုံးပါ။
6. **Model အခြေပြုထိန်းချုပ်မှု** (computed torque၊ feedforward) သည် PID သက်သက်ထက် ပိုကောင်းနိုင်သည်။
7. **အမှန်တကယ် hardware ပေါ်တွင် အမြဲစမ်းသပ်ပါ**: friction၊ backlash၊ saturation နှင့် delay တို့ကို ထည့်တွက်ပါ။

---