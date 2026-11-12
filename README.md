# Buckeye Silicon Entry Project: Vending Machine Controller

This project is your entry into Buckeye Silicon's project teams. You'll design the control logic for a simple vending machine in SystemVerilog, using everything from the bootcamp: combinational logic, registers, arithmetic, and state machines. It's meant to be challenging but doable on your own in two weeks.

**Due: December 4th at 11:59 PM. Late submissions are NOT accepted.**

---

## Getting started

You need a free GitHub account. Everything below works entirely in your browser, no installs required.

1. **Make your own copy.** At the top of this page, click **Use this template → Create a new repository**. Set the owner to your own account, name it `vending-machine-project`, and set visibility to **Private**.
2. **Give us access.** In your new repository, go to **Settings → Collaborators → Add people** and add `Shareef-Anani` and `adam-arebi`. We can't grade a repository we can't see.
3. **Open the editor.** On your repository's main page, press the `.` key on your keyboard. A code editor opens in your browser.
4. **Write your modules.** Fill in the three files in `src/`. To simulate, copy your code into the nanoHUB tool, test it there, and paste any fixes back.
5. **Save your work.** Click the Source Control icon in the left sidebar, type a short message describing what you changed, and click **Commit & Push**. Commit often, not just at the end.

Already comfortable with Git? You can `git clone` your repository and work locally instead.

---

## Repository layout

```
src/
  coin_decoder.sv    <- you write this
  datapath.sv        <- you write this
  controller.sv      <- you write this
provided/
  vending_top.sv     <- connects your modules. Do not edit.
```

Only change the three files in `src/`. Do not rename them, and do not change any module name or port list. If your ports don't match exactly, your modules won't connect during grading.

---

## How the machine works

The machine sells one item that costs **50 cents**. It accepts nickels, dimes, and quarters. At most one coin can arrive per clock cycle, and most cycles have no coin at all.

The machine keeps a running total of how much money has been inserted, called the **credit**. Every time a coin arrives, its value is added to the credit. When the credit reaches 50 cents or more, then on the **next** clock cycle the machine:

1. Sets `dispense` high for **exactly one** clock cycle
2. Outputs the change (credit minus 50) on `change`
3. Resets the credit to zero

Then it goes back to waiting for coins.

### Coin encoding

| `coin`  | Meaning | Value |
|---------|---------|-------|
| `2'b00` | No coin | 0¢    |
| `2'b01` | Nickel  | 5¢    |
| `2'b10` | Dime    | 10¢   |
| `2'b11` | Quarter | 25¢   |

---

## What you'll build

Three modules. Each file in `src/` already contains its port list.

**Coin decoder** (`src/coin_decoder.sv`): converts the 2-bit coin code into a value in cents. Purely combinational, with no clock.

**Datapath** (`src/datapath.sv`): holds the credit and does all the math. It never decides anything on its own. It only acts on signals from the controller.

**Controller** (`src/controller.sv`): a state machine that decides what happens. It never touches a number. It only looks at `enough` and tells the datapath what to do.

### Signal reference

| Signal     | From         | To           | Meaning                                       |
|------------|--------------|--------------|-----------------------------------------------|
| `value`    | coin decoder | datapath     | Value of the current coin in cents            |
| `load`     | controller   | datapath     | Add `value` to the credit                     |
| `clear`    | controller   | datapath     | Reset the credit to 0                         |
| `enough`   | datapath     | controller   | Credit plus `value` is 50 or more             |
| `change`   | datapath     | output       | Credit minus 50                               |
| `dispense` | controller   | output       | High for exactly one cycle per sale           |

`provided/vending_top.sv` wires everything together. You don't write or submit it, but read it: it shows exactly how your three modules connect.

---

## Example transaction

A dime, a quarter, and a quarter, with empty cycles in between:

| Cycle | Coin in | Credit | `dispense` | `change` |
|-------|---------|--------|------------|----------|
| 1     | dime    | 0      | 0          |          |
| 2     | none    | 10     | 0          |          |
| 3     | none    | 10     | 0          |          |
| 4     | quarter | 10     | 0          |          |
| 5     | none    | 35     | 0          |          |
| 6     | quarter | 35     | 0          |          |
| 7     | none    | 60     | 1          | 10       |
| 8     | none    | 0      | 0          |          |

Credit holds its value during cycles with no coin. The quarter on cycle 6 pushes credit to 60, so `dispense` goes high on cycle 7 with 10 cents of change, then credit clears.

---

## Rules and guarantees

- Reset is synchronous and active-high. When `rst` is 1 at a clock edge, credit returns to 0 and the machine returns to waiting for coins.
- No coin will arrive during the cycle when `dispense` is high.
- `change` is only checked while `dispense` is high. What it shows at other times doesn't matter.

---

## Hints

- Start with the coin decoder. It's the easiest module, and you can check it by trying all four coin values.
- Draw your state diagram on paper before writing the controller. You need fewer states than you might think.
- If your controller contains a `+` or a `>=`, that logic belongs in the datapath.
- Use `<=` inside `always_ff` and `=` inside `always_comb`. Mixing them up is the most common beginner bug.
- In an `always_comb` block, give every output a default value at the top so you don't accidentally create a latch.
- `dispense` must be high for exactly one cycle. If it's based directly on how much credit there is, it will stay high too long. Think about what kind of signal naturally lasts exactly one cycle.
- Work out the largest value credit can ever reach. Why do you think the signals are 7 bits wide?
- Compare your waveform cycle by cycle against the example table above, especially which cycle `dispense` goes high on.

---

## Resources

- [HDLBits](https://hdlbits.01xz.net/wiki/Main_Page): short Verilog exercises you solve in the browser with instant feedback on whether your circuit works. The sequential logic and finite state machine problem sets are excellent practice for this project.
- [EDA Playground](https://edaplayground.com): a free browser-based simulator with a built-in waveform viewer. No installation, just a free account.
- [Nandland: Blocking vs. Nonblocking](https://nandland.com/blocking-vs-nonblocking-in-verilog/): when to use `=` versus `<=`, explained clearly.
- [Nandland: How to Avoid Latches](https://nandland.com/how-to-avoid-creating-a-latch/): why latches appear by accident in combinational logic and how to prevent them.
- [ChipVerify: SystemVerilog always blocks](https://chipverify.com/systemverilog/systemverilog-always): how `always_comb` and `always_ff` work.
- [Cambridge Verilog Tutorial, Part 3: State Machines](https://www.cl.cam.ac.uk/teaching/2526/ECAD+Arch/verilogtutor3.html): state machines in SystemVerilog, using `always_comb` for the logic and `always_ff` only to update state.
- [Berkeley EECS150: FSMs in Verilog](https://inst.eecs.berkeley.edu/~cs150/sp10/Collections/FSM.pdf): a guide to writing Moore state machines. Older and in plain Verilog, but the concepts carry over directly.

---

## Submitting

1. Make sure your final code is committed and pushed.
2. On your repository's main page, click the **commits** link (it has a clock icon and a number) above the file list, then click your most recent commit. Copy the URL from your browser. It should look like `github.com/your-username/vending-machine-project/commit/...`
3. Paste that link into a Discord DM with at least 1 Buckeye Silicon Board Member.

We grade exactly the commit you submit, and the form's timestamp is your submission time. You can submit the form more than once before the deadline. We'll grade your most recent submission.

**Before you submit, check that:**

- [ ] Your repository is **private** and `Shareef-Anani` + `adam-arebi` are collaborators
- [ ] You only changed the three files in `src/`
- [ ] No module names or port lists were changed
- [ ] Your commit link is submitted before the deadline

---

## A note on AI

We encourage you to use AI to help you learn. Asking it to explain a concept, why your code won't compile, or what a waveform is showing you is a great way to study. But using AI to write this project for you is strongly discouraged. This project exists so you can prove to yourself, and to us, that you can design hardware on your own, and every line you outsource is something you didn't learn. You'd only be hurting your own learning.

If we have strong reason to believe a submission was written by AI, you may not be placed on a project team this semester and will be deferred to the next cohort. We may ask you to briefly walk us through your design.

---

## Questions

Talk to us before/after weekly meetings
Reach out to a Buckeye Silicon board member on discord
