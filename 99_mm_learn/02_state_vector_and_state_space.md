# State-Space ကိုယ်စားပြုမှုနှင့် State Vector

*ထိန်းချုပ်မှုစနစ်နှင့် စက်ရုပ်များတွင် state-space မော်ဒယ်တည်ဆောက်ပုံကို နားလည်ရန် လက်တွေ့လမ်းညွှန်။*

---

## မာတိကာ

1. [State Space ဆိုတာဘာလဲ?](#state-space-ဆိုတာဘာလဲ)
2. [State Vector](#state-vector)
3. [ဆက်တိုက်အချိန် State-Space မော်ဒယ်](#ဆက်တိုက်အချိန်-state-space-မော်ဒယ်)
4. [Matrix များ၏ အဓိပ္ပာယ်](#matrix-များ၏-အဓိပ္ပာယ်)
5. [စက်ရုပ်ဥပမာ: DC Motor](#စက်ရုပ်ဥပမာ-dc-motor)
6. [State Space ကို ဘာကြောင့်သုံးသလဲ?](#state-space-ကို-ဘာကြောင့်သုံးသလဲ)
7. [Discrete-Time (ဒစ်ဂျစ်တယ်ထိန်းချုပ်မှု)](#discrete-time-ဒစ်ဂျစ်တယ်ထိန်းချုပ်မှု)
8. [အဓိကဂုဏ်သတ္တိများ: Controllability နှင့် Observability](#အဓိကဂုဏ်သတ္တိများ-controllability-နှင့်-observability)
9. [Canonical Form များ](#canonical-form-များ)
10. [State Feedback (Pole Placement)](#state-feedback-pole-placement)
11. [Observer ဒီဇိုင်း (State ခန့်မှန်းခြင်း)](#observer-ဒီဇိုင်း-state-ခန့်မှန်းခြင်း)
12. [အကျဉ်းချုပ်](#အကျဉ်းချုပ်)

---

## State Space ဆိုတာဘာလဲ?

**State space** သည် **state variable** များဖြင့် စနစ်အတွင်းပိုင်းအပြုအမူကို ဖော်ပြသော သင်္ချာနည်းလမ်းဖြစ်သည်။ အဝင်နှင့်အထွက်ကိုသာ ဆက်စပ်ပြသသည့် transfer function နှင့်မတူဘဲ state-space မော်ဒယ်သည် **စနစ်အတွင်း ဘာဖြစ်နေသည်ကို** ဖော်ပြနိုင်သည်။

### အဓိကအယူအဆ

> အချိန် `t₀` ရှိ **state** နှင့် `t₀` မှစ၍ နောက်ပိုင်း **input** `u(t ≥ t₀)` အားလုံးကို သိလျှင် အနာဂတ် **output** များကို ခန့်မှန်းနိုင်သည်။

**State** သည် စနစ်၏ ယခင်သမိုင်းကို အကျဉ်းချုပ်ပြီး အနာဂတ်အပြုအမူကို ခန့်မှန်းရန် လိုအပ်သည့် အနည်းဆုံး variable အစုဖြစ်သည်။

---

## State Vector

### အဓိပ္ပာယ်

**State vector** `x(t)` သည် state variable များအားလုံးကို ထည့်ထားသော column vector ဖြစ်သည်:

$$
x(t) = \begin{bmatrix} x_1(t) \\ x_2(t) \\ \vdots \\ x_n(t) \end{bmatrix} \in \mathbb{R}^n
$$

ဤနေရာတွင်:
- `n` = **system order** (တစ်ခုနှင့်တစ်ခု သီးခြားဖြစ်သော စွမ်းအင်သိုလှောင်အစိတ်အပိုင်း အရေအတွက်)
- `xᵢ(t)` တစ်ခုစီ = **state variable** (ဥပမာ တည်နေရာ၊ အလျင်၊ လျှပ်စီး၊ capacitor ပေါ်ဗို့အား)

### ဘယ်လို Variable မျိုးကို State Variable ဟု သတ်မှတ်သလဲ?

Variable တစ်ခုသည် state ဖြစ်ရန်:
1. **စွမ်းအင်သိုလှောင်မှု** ကို ကိုယ်စားပြုရမည် (capacitor ဗို့အား၊ inductor လျှပ်စီး၊ ဒြပ်ထု၏ တည်နေရာ/အလျင်၊ စပရင်ဖိသိပ်မှု)။
2. ၎င်း၏ derivative သည် လက်ရှိ state နှင့် input များပေါ် မူတည်ရမည်။
3. အနာဂတ်အပြုအမူကို ခန့်မှန်းရန် လိုအပ်သော **အနည်းဆုံးအစု** ထဲတွင် ပါဝင်ရမည်။

### နယ်ပယ်အလိုက် ရုပ်ပိုင်းဆိုင်ရာ ဥပမာများ

| နယ်ပယ် | တွေ့ရလေ့ရှိသော State Variable များ |
|---|---|
| **စက်ပိုင်းဆိုင်ရာ** | တည်နေရာ `x`၊ အလျင် `v` (သို့မဟုတ် momentum `p=mv`) |
| **လျှပ်စစ်** | Capacitor ဗို့အား `v_C`၊ inductor လျှပ်စီး `i_L` |
| **အပူ** | အပူချိန် `T` (အပူစွမ်းအင်) |
| **ဟိုက်ဒရောလစ်** | ဖိအား `p`၊ စီးဆင်းနှုန်း `q` |
| **ဓာတု** | အာရုံစူးစိုက်မှု `c`၊ တုံ့ပြန်မှုအတိုင်းအတာ |

---

## ဆက်တိုက်အချိန် State-Space မော်ဒယ်

### ပုံမှန်ပုံစံ

$$
\begin{aligned}
\dot{x}(t) &= A x(t) + B u(t) \quad &\text{(State equation / ဒိုင်နမစ်)} \\
y(t) &= C x(t) + D u(t) \quad &\text{(Output equation / တိုင်းတာမှု)}
\end{aligned}
$$

ဤနေရာတွင်:
- `x(t) ∈ ℝⁿ` — **State vector** (`n` states)
- `u(t) ∈ ℝᵐ` — **Input vector** (`m` inputs)
- `y(t) ∈ ℝᵖ` — **Output vector** (`p` outputs)

### Block Diagram

```
                    ┌──────────────┐
u(t) ──────────────►│      B       │──────►┐
                    └──────────────┘       │
                                          ▼
                    ┌──────────────┐    ┌─────┐    ┌──────────────┐
                    │     A        │◄───│ x(t) │───►│      C       │──► y(t)
                    └──────────────┘    └─────┘    └──────────────┘
                         ▲               │
                         │               │
                         └───────────────┘
                              (ဒိုင်နမစ်)
```

### Matrix အရွယ်အစားများ

| Matrix | အရွယ်အစား | အမည် | အခန်းကဏ္ဍ |
|---|---|---|---|
| **A** | n × n | **System matrix** | အတွင်းပိုင်းဒိုင်နမစ်နှင့် state အချင်းချင်းသက်ရောက်မှု |
| **B** | n × m | **Input matrix** | Input များက state များကို မည်သို့သက်ရောက်သည် |
| **C** | p × n | **Output matrix** | မည်သည့် state များကို တိုင်းတာသည် |
| **D** | p × m | **Feedthrough** | Input မှ output သို့ တိုက်ရိုက်သက်ရောက်မှု |

---

## စက်ရုပ်ဥပမာ: DC Motor (Position Control)

### ရုပ်ပိုင်းဆိုင်ရာ ညီမျှခြင်းများ

Armature ကိုထိန်းချုပ်သော DC motor အတွက်:

**လျှပ်စစ်:** `L di/dt + R i = V - Kₑ ω`

**စက်ပိုင်း:** `J dω/dt + b ω = Kₜ i`

ဤနေရာတွင်:
- `V` = armature ဗို့အား (input)
- `i` = armature လျှပ်စီး
- `ω` = ထောင့်အလျင်
- `θ` = ထောင့်တည်နေရာ (output)
- `L, R` = inductance၊ resistance
- `J, b` = inertia၊ damping
- `Kₜ, Kₑ` = torque constant၊ back-EMF constant

### State များကို ရွေးချယ်ခြင်း

စွမ်းအင်သိုလှောင်အစိတ်အပိုင်းများ:
1. **Inductor** → လျှပ်စီး `i` (သံလိုက်စွမ်းအင် ½Li²)
2. **Inertia** → အလျင် `ω` (ရွေ့လျားစွမ်းအင် ½Jω²)
3. **တည်နေရာ** `θ` သည် အလျင်၏ integral ဖြစ်သည်။

**State vector:**
$$
x = \begin{bmatrix} \theta \\ \omega \\ i \end{bmatrix} = \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix}
$$

### State Equation များကို ဆင်းသက်ခြင်း

ရုပ်ပိုင်းဆိုင်ရာ ညီမျှခြင်းများမှ:
```
ẋ₁ = θ̇ = ω = x₂
ẋ₂ = ω̇ = (Kₜ/J) i - (b/J) ω = (Kₜ/J)x₃ - (b/J)x₂
ẋ₃ = i̇ = (1/L)V - (R/L)i - (Kₑ/L)ω = (1/L)V - (R/L)x₃ - (Kₑ/L)x₂
```

**Matrix ပုံစံ:**
$$
\begin{bmatrix} \dot{x}_1 \\ \dot{x}_2 \\ \dot{x}_3 \end{bmatrix} =
\begin{bmatrix}
0 & 1 & 0 \\
0 & -b/J & K_t/J \\
0 & -K_e/L & -R/L
\end{bmatrix}
\begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} +
\begin{bmatrix} 0 \\ 0 \\ 1/L \end{bmatrix} V
$$

**Output equation** (တည်နေရာကို တိုင်းတာလျှင်):
$$y = \theta = x_1 = \begin{bmatrix} 1 & 0 & 0 \end{bmatrix}x$$

### Matrix အပြည့်အစုံ

```matlab
A = [0, 1,     0;
     0, -b/J,  Kt/J;
     0, -Ke/L, -R/L];

B = [0; 0; 1/L];

C = [1, 0, 0];

D = [0];
```

---

## State Space ကို ဘာကြောင့်သုံးသလဲ? (Transfer Function နှင့် နှိုင်းယှဉ်ခြင်း)

| အချက် | Transfer Function | State Space |
|---|---|---|
| **အတွင်းပိုင်းအပြုအမူ** | ဖုံးကွယ်ထားသည် (black box) | တိတိကျကျ ဖော်ပြထားသည် (white box) |
| **MIMO စနစ်များ** | အသုံးပြုရခက်သည် (TF matrix လိုအပ်) | သဘာဝကျသည် (vector/matrix) |
| **ကနဦးအခြေအနေများ** | ကိုင်တွယ်ရခက်သည် | တိုက်ရိုက်ထည့်နိုင်သည် (`x(0)`) |
| **အချိန်ပြောင်းလဲစနစ်များ** | မကိုင်တွယ်နိုင် | သင့်လျော်သည် |
| **Nonlinear စနစ်များ** | မကိုင်တွယ်နိုင် | သဘာဝကျစွာ တိုးချဲ့နိုင်သည် |
| **Optimal control (LQR)** | ခက်ခဲသည် | တိုက်ရိုက်ပုံစံချနိုင်သည် |
| **Observer ဒီဇိုင်း** | မသင့်လျော် | Kalman filter၊ Luenberger ကို သုံးနိုင်သည်။ |
| **Model predictive control** | အသုံးပြုရခက်သည် | မူရင်းပုံစံနှင့် ကိုက်ညီသည်။ |

**အနှစ်ချုပ်**: SISO ကြိမ်နှုန်းဒိုမိန်း ဆန်းစစ်မှုအတွက် transfer function သည် အသုံးဝင်သည်။ MIMO၊ optimal control၊ state ခန့်မှန်းမှုနှင့် ခေတ်မီစက်ရုပ်များအတွက် state space သည် အရေးကြီးသည်။

---

## Discrete-Time (ဒစ်ဂျစ်တယ်ထိန်းချုပ်မှု)

Sampling time `Tₛ` အတွက်:

$$
\begin{aligned}
x[k+1] &= A_d x[k] + B_d u[k] \\
y[k]   &= C_d x[k] + D_d u[k]
\end{aligned}
$$

### ပြောင်းလဲနည်းများ (ဆက်တိုက်မှ ဒစ်ဂျစ်တယ်သို့)

| နည်းလမ်း | ဖော်မြူလာ | အသုံးပြုရန်သင့်တော်မှု |
|---|---|---|
| **Zero-Order Hold (ZOH)** | $A_d=\exp(A T_s)$, $B_d=A^{-1}(A_d-I)B$ | ဒစ်ဂျစ်တယ်ထိန်းချုပ်မှုအများစု |
| **Tustin (Bilinear)** | $A_d=(I-\frac{1}{2}A T_s)^{-1}(I+\frac{1}{2}A T_s)$ | ကြိမ်နှုန်းတုံ့ပြန်မှု ပိုမိုထိန်းသိမ်းရန် |
| **Forward Euler** | $A_d=I+A T_s$ | ရိုးရှင်းသော်လည်း တိကျမှုနည်း |
| **Matched Pole-Zero** | Pole/zero များကို တိုက်ရိုက် mapping လုပ်သည်။ | ကြိမ်နှုန်းတုံ့ပြန်မှုကို ထိန်းသိမ်းရန် |

### MATLAB ဖြင့် ပြောင်းလဲခြင်း

```matlab
sys_c = ss(A, B, C, D);      % ဆက်တိုက်စနစ်
sys_d = c2d(sys_c, Ts, 'tustin');  % ကြိမ်နှုန်းတုံ့ပြန်မှုကို ကောင်းစွာထိန်းသိမ်း
% သို့မဟုတ်
sys_d = c2d(sys_c, Ts, 'zoh');     % ဒစ်ဂျစ်တယ်ထိန်းချုပ်မှုတွင် အသုံးများ
```

### Python (control library)

```python
import control as ctrl
sys_c = ctrl.ss(A, B, C, D)
sys_d = ctrl.sample_system(sys_c, Ts, method='tustin')
```

---

## အဓိကဂုဏ်သတ္တိများ: Controllability နှင့် Observability

### Controllability

**Input များသုံးပြီး state ကို မည်သည့်အခြေအနေသို့မဆို မောင်းနှင်နိုင်သလား?**

**Controllability matrix:**
$$
\mathcal{C} = \begin{bmatrix} B & AB & A^2B & \cdots & A^{n-1}B \end{bmatrix}
$$

**စံသတ်မှတ်ချက်:** `rank(𝒞) = n` ဖြစ်လျှင် **အပြည့်အဝ controllable** ဖြစ်သည်။

မပြည့်စုံလျှင် input ဖြင့် သက်ရောက်မှုမပြုနိုင်သော state များ၊ သို့မဟုတ် controllable မဟုတ်သော mode များ ရှိသည်။

```matlab
ctrb = rank(ctrb(A, B));  % သို့မဟုတ် ctrb = ctrb(A, B); rank(ctrb)
```

### Observability

**Output များမှ အတွင်းပိုင်း state များကို ခန့်မှန်းသိရှိနိုင်သလား?**

**Observability matrix:**
$$
\mathcal{O} = \begin{bmatrix} C \\ CA \\ CA^2 \\ \vdots \\ CA^{n-1} \end{bmatrix}
$$

**စံသတ်မှတ်ချက်:** `rank(𝒪) = n` ဖြစ်လျှင် **အပြည့်အဝ observable** ဖြစ်သည်။

မပြည့်စုံလျှင် output များမှ မသိရှိနိုင်သော state သို့မဟုတ် unobservable mode အချို့ရှိသည်။

```matlab
obsv = rank(obsv(A, C));  % သို့မဟုတ် obsv = obsv(A, C); rank(obsv)
```

### Duality

`(A, B)` ၏ controllability ⇔ `(Aᵀ, Bᵀ)` ၏ observability

ထို့ကြောင့်:
- Pole placement တွင် `place(A, B, p)` ကို သုံးသည်။
- Observer ဒီဇိုင်းတွင် `place(A', C', p)'` ကို သုံးသည်။

---

## Canonical Form များ

Input/output အပြုအမူတူညီသော်လည်း အတွင်းပိုင်းဖွဲ့စည်းပုံ မတူသည့် matrix ကိုယ်စားပြုမှုများဖြစ်သည်။

| Form | A Matrix | အသုံးပြုပုံ |
|---|---|---|
| **Controllable** | Companion | Pole placement၊ controller ဒီဇိုင်း |
| **Observable** | Companionᵀ | Observer ဒီဇိုင်း |
| **Modal** | Diagonal (poles သီးခြားဖြစ်လျှင်) | Modal analysis၊ coupling ခွဲထုတ်ရန် |
| **Balanced** | Σ = Σ_c = Σ_o | Model လျှော့ချရန် |

### Transformation

State-space မော်ဒယ်တိုင်းကို similarity transform `T` ဖြင့် ပြောင်းလဲနိုင်သည်:

```
x̄ = T x
Ā = T A T⁻¹
B̄ = T B
C̄ = C T⁻¹
```

---

## State Feedback (Pole Placement)

### ထိန်းချုပ်မှု ဥပဒေ

```
u = -K x + r
```

ဤနေရာတွင်:
- `K` = state feedback gain (m × n)
- `r` = reference input

**Closed-loop ဒိုင်နမစ်:**
$$\dot{x} = (A - B K)x + B r$$

### ဒီဇိုင်းရည်မှန်းချက်

`(A - B K)` ၏ eigenvalue များကို လိုချင်သော closed-loop pole များဖြစ်စေရန် `K` ကို ရွေးချယ်ပါ။

```matlab
% MATLAB
K = place(A, B, p_desired);    % ကိန်းဂဏန်းပိုင်းအရ တည်ငြိမ်သောနည်း
% သို့မဟုတ်
K = acker(A, B, p_desired);    % Ackermann's formula
```

### လိုချင်သော Pole များကို ရွေးချယ်ခြင်း

| စဉ်းစားရန် | လမ်းညွှန်ချက် |
|---|---|
| **Dominant poles** | Open-loop ထက် 2-5 ဆ ပိုမြန်စွာထားပါ။ |
| **Damping** | ကောင်းသော transient အတွက် ζ ≈ 0.7 |
| **Bandwidth** | လိုချင်သော closed-loop bandwidth ထက် 5-10 ဆ |
| **Control effort** | အလွန်မြန်သော poles မရွေးပါနှင့် (actuator saturation ဖြစ်နိုင်သည်)။ |
| **Noise** | Sensor noise ပိုကြီးစေနိုင်သောကြောင့် pole များကို အလွန်မြန်အောင် မထားပါနှင့်။ |

### စက်ရုပ်ဆိုင်ရာ အသုံးချမှု

Plant `1/(s(s+2)(s+5))` ရှိသော joint တစ်ခုအတွက်:

```matlab
% လိုချင်သော: ζ=0.7, ωn=20 rad/s → dominant poles -14 ± j14
p_desired = [-14+14i, -14-14i, -100];  % တတိယ pole ကို ဘယ်ဘက်အဝေးတွင်ထားသည်။
K = place(A, B, p_desired);
```

---

## Observer ဒီဇိုင်း (State ခန့်မှန်းခြင်း)

### ပြဿနာ

State အားလုံးကို sensor ဖြင့် တိုင်းတာမရနိုင်ပါ။ ထို့ကြောင့် ၎င်းတို့ကို **ခန့်မှန်းရန်** လိုအပ်သည်။

### Luenberger Observer

```
ẋ̂ = A x̂ + B u + L (y - C x̂)
```

ဤနေရာတွင်:
- `x̂` = ခန့်မှန်းထားသော state
- `L` = observer gain (n × p)
- `y - C x̂` = output ခန့်မှန်းမှုအမှား (innovation)

**ခန့်မှန်းမှုအမှား၏ ဒိုင်နမစ်:**
$$\dot{\tilde{x}} = (A - LC)\tilde{x}, \quad \tilde{x}=x-\hat{x}$$

### ဒီဇိုင်း

Observer poles များကို controller poles ထက် 2-5 ဆ ပိုမြန်စေရန် ရွေးချယ်ပါ:

```matlab
% Controller poles
p_ctrl = [-14+14i, -14-14i, -100];

% Observer poles (2-3x ပိုမြန်)
p_obs = 3 * p_ctrl;  % [-42+42i, -42-42i, -300]

% Observer gain (pole placement ၏ dual ပုံစံ)
L = place(A', C', p_obs)';
```

### Kalman Filter (အကောင်းဆုံး Observer)

Process noise `w` နှင့် measurement noise `v` ရှိသော noise ပါစနစ်အတွက်:

```
ẋ = A x + B u + w
y = C x + v
```

Covariance များ: `E[w wᵀ] = Q`, `E[v vᵀ] = R`

```matlab
[L, P, E] = kalman(sys_ss, Q, R);
```

ဤနေရာတွင်:
- `L` = အကောင်းဆုံး gain
- `P` = steady-state error covariance
- `E` = closed-loop observer poles

---

## အကျဉ်းချုပ်

| အယူအဆ | အဓိကမှတ်သားရန် |
|---|---|
| **State vector** | အနာဂတ်ကို ခန့်မှန်းရန် လိုအပ်သော အနည်းဆုံး variable အစု; column vector `x ∈ ℝⁿ` |
| **State equation** | `ẋ = Ax + Bu` — state များ ပြောင်းလဲပုံ |
| **Output equation** | `y = Cx + Du` — တိုင်းတာရရှိသည့် output |
| **A matrix** | အတွင်းပိုင်းဒိုင်နမစ်နှင့် state အချင်းချင်းသက်ရောက်မှု |
| **B matrix** | Input များက state များကို သက်ရောက်ပုံ |
| **C matrix** | မည်သည့် state များကို တိုင်းတာသည် |
| **Controllability** | State ကို မောင်းနှင်နိုင်သလား? `rank([B AB ...]) = n` |
| **Observability** | Output မှ state ကို ခန့်မှန်းနိုင်သလား? `rank([C; CA; ...]) = n` |
| **State feedback** | `u=-Kx` → `K=place(A,B,p)` ဖြင့် poles သတ်မှတ်နိုင်သည်။ |
| **Observer** | `L=place(A',C',p)'` ဖြင့် state ခန့်မှန်းသည်။ |
| **Kalman filter** | Noise ပါစနစ်အတွက် အကောင်းဆုံး observer |

### စက်ရုပ်များတွင် အသုံးပြုသင့်သည့်အချိန်

- **Joint control**: joint တစ်ခုစီအတွက် `x=[θ, ω]`
- **Mobile robot**: `x=[x, y, θ, v, ω]`
- **Sensor fusion**: Kalman filter (IMU + encoder + vision)
- **MPC**: State space သည် မူရင်းသင့်လျော်သော ဖွဲ့စည်းပုံဖြစ်သည်။
- **Computed torque**: Feedforward တွင် state အပြည့်အစုံလိုအပ်သည်။

---

*ထပ်မံလေ့လာရန်: Åström & Murray "Feedback Systems" (အခန်း 6-7), Kailath "Linear Systems", Franklin et al. "Feedback Control of Dynamic Systems" (အခန်း 3, 7-8).*