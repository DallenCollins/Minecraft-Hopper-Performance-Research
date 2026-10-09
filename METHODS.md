# Experimental Methodology

## The Diminishing Returns of Hopper-Check Intervals

**Project:** Minecraft Hopper Performance Research  
**Server Software:** Paper 26.2  
**Server Host:** PebbleHost  
**World:** Redstone Ready Superflat World  
**Performance Monitoring:** Spark Profiler  
**Statistical Analysis:** R 4.6.1 / RStudio  
**Sample Size:** 48 completed trials  
**Experimental Design:** Randomized Complete Block Design

---

## 1. Research Objective

The purpose of this experiment was to investigate how changes to Minecraft Paper's hopper-check interval affect server processing performance.

Increasing the interval between hopper inventory checks is one method of reducing server workload. However, less frequent checks may also affect hopper responsiveness, potentially interfering with automated storage systems and other technical machinery.

This investigation sought to determine whether increasing hopper-check produces proportional reductions in server processing time or whether the performance improvements diminish at higher intervals.

### Research Question

**How does increasing the hopper-check interval affect server performance, and at what point do additional increases produce diminishing returns?**

### Hypothesis

Increasing hopper-check will initially produce substantial improvements in server performance, but additional improvements will become progressively smaller as the interval increases.

The independent variable was the hopper-check interval.

The primary dependent variable was median milliseconds per tick (MSPT), as reported by Spark.

Additional observations included 95th-percentile MSPT, maximum MSPT, and reported CPU usage.

---

## 2. Experimental Environment

### Server Configuration

All experiments were conducted on a dedicated Minecraft Paper server hosted through PebbleHost.

The server was created specifically for performance testing and was not used for ordinary multiplayer gameplay.

| Parameter | Configuration |
|---|---|
| Server Software | Paper 26.2 |
| Server Host | PebbleHost |
| World Type | Redstone Ready Superflat World |
| Other Players | None |
| Unrelated Builds | None |
| Hopper Population | 10,000 |
| Hopper-Check Settings | 1, 2, 4, 8, 16 |
| Hopper-Transfer | 8 |
| Performance Monitoring | Spark Profiler |
| Statistical Analysis | R / RStudio |

The experimenter was the only player connected during testing.

The same server and test world were used throughout the experiment.

The exact Paper build identifier, server processor, allocated memory, Java runtime, and Spark version were not recorded in the available documentation.

### Hopper Arrangement

The experimental setup consisted of **10,000 empty hoppers**, arranged in a flat horizontal array.

The hoppers had the following characteristics:

- All 10,000 hoppers faced downward.
- Every hopper was empty.
- No items were transported through the system.
- The hoppers were suspended two blocks above the world floor.
- Only air was present above and around the hoppers.
- No containers or other inventories were placed above the hoppers.

The arrangement was generated using Minecraft's `/fill` command.

The test population occupied a single horizontal layer measuring 100 × 100 blocks.

Example commands used to create and remove the hopper array:

**Place 10,000 hoppers:**

```mcfunction
/fill -15 58 42 84 58 141 minecraft:hopper
```

**Remove 10,000 hoppers:**

```mcfunction
/fill -15 58 42 84 58 141 air replace minecraft:hopper
```

The same test location and hopper arrangement were maintained throughout the experiment.

### Scope of the Hopper Workload

This experiment specifically investigated an array of empty, downward-facing hoppers operating without active item transportation.

The results therefore characterize server performance under this idle hopper workload.

They should not automatically be generalized to hoppers actively transferring items, sorting inventories, or interacting with containers.

---

## 3. Experimental Design

A randomized complete block design was used to compare hopper-check conditions while reducing systematic variation associated with test order.

The experiment consisted of eight randomized blocks.

Each block contained six experimental conditions:

| Condition | Hopper-Check | Hopper Population |
|---|---:|---:|
| Baseline | Not applicable | 0 |
| HC 1 | 1 | 10,000 |
| HC 2 | 2 | 10,000 |
| HC 4 | 4 | 10,000 |
| HC 8 | 8 | 10,000 |
| HC 16 | 16 | 10,000 |

Each condition was measured once per block.

This produced eight measurements per condition and a total of 48 completed trials.

### Randomization

The experimental sequence was generated in R using a fixed random seed to permit reproduction.

```r
set.seed(42)

settings <- c(0, 1, 2, 4, 8, 16)

test_order <- data.frame(
  Block = rep(1:8, each = 6),
  Trial = 1:48,
  Hopper_Check = unlist(
    replicate(
      8,
      sample(settings),
      simplify = FALSE
    )
  )
)

test_order$Condition <- ifelse(
  test_order$Hopper_Check == 0,
  "Baseline",
  paste0("HC ", test_order$Hopper_Check)
)

print(test_order)
```

The six experimental conditions were randomized independently within each block.

Testing followed the resulting sequence rather than testing all repetitions of one setting consecutively.

This approach helped distribute potential time-dependent variation across experimental conditions.

---

## 4. Experimental Procedure

Each of the 48 completed trials was conducted according to the same general procedure.

### Step 1: Configure the Experimental Condition

The next condition was identified from the randomized sequence generated in R.

For hopper-check trials, the server's hopper-check configuration was set to the assigned value.

All 10,000 test hoppers were present during these trials.

For baseline trials, the 10,000 hoppers were removed using the `/fill` command, replacing them with air.

After baseline measurements were completed, the hopper array was restored using `/fill` before subsequent hopper-check measurements.

### Step 2: Restart the Server

The Paper server was restarted after configuring the experimental condition.

This included baseline trials in which the hopper population had been removed.

Restarting ensured that configuration changes were applied before performance measurements began.

The same restart procedure was used for both baseline and hopper-check conditions.

### Step 3: Join the Server

After the server restarted, the experimenter logged into Minecraft and joined the test server.

During every trial, the player remained in a consistent position:

- Flying above the center of the hopper array
- Facing south
- Remaining stationary
- Performing no in-game actions during profiling

For baseline trials, the same viewing position was used even though the hoppers had been removed.

Maintaining a consistent player position and viewing direction was intended to reduce variation associated with player movement and changes in loaded world regions.

### Step 4: Stabilization Period

After joining the server, the experimenter waited approximately 30 seconds before beginning the measurement.

The purpose of this delay was to allow the server to settle following its restart and the player's login.

The stabilization period was standardized across trials.

However, the experiment did not independently establish that all startup-related background processes had finished during this period.

### Step 5: Start Spark Profiling

The following command was entered:

```mcfunction
/spark profiler start
```

At approximately the same moment the command was submitted, a separate 60-second timer was started.

The timer provided a consistent external reference for profiling duration.

During the profiling period, the experimenter remained stationary while flying above the test area and facing south.

No blocks were placed, removed, or interacted with during the measurement.

### Step 6: Stop Spark Profiling

When the 60-second timer expired, the following command was executed:

```mcfunction
/spark profiler stop
```

Because the commands were initiated manually, the actual profiling duration may have differed slightly from exactly 60 seconds.

All completed trials used the same manual timing method.

### Step 7: Record Performance Measurements

After profiling was stopped, the generated Spark report link was opened.

The available performance measurements were recorded and associated with the corresponding trial number and experimental condition.

Recorded measurements included:

- Median MSPT
- 95th-percentile MSPT
- Maximum MSPT
- Reported 1-minute process CPU usage
- Reported 15-minute process CPU usage

Median MSPT was designated as the primary response variable.

### Step 8: Repeat in Randomized Order

The procedure was repeated for the next condition specified by the R-generated randomized trial sequence.

After all six conditions in a block had been completed, testing continued with the next randomized block.

A total of 48 completed trials were recorded.

One interrupted testing attempt was repeated rather than included as a completed trial.

---

## 5. Data Collection and Organization

Experimental measurements were recorded and analyzed using RStudio.

### Primary Dataset

The original dataset, `hopper_randomized_trials.csv`, contains the following columns:

| Variable | Description |
|---|---|
| `Block` | Randomized experimental block, 1–8 |
| `Trial` | Trial number, 1–48 |
| `Hopper_Check` | Configured interval; 0 indicates baseline |
| `Condition` | Experimental condition label |
| `MSPT` | Recorded median MSPT in milliseconds |

### Expanded Dataset

Additional Spark measurements were subsequently included in `hopper_complete_data.csv`.

| Variable | Description |
|---|---|
| `P95_MSPT` | Recorded 95th-percentile MSPT |
| `Max_MSPT` | Recorded maximum MSPT |
| `CPU_1min` | Reported 1-minute process CPU usage |
| `CPU_15min` | Reported 15-minute process CPU usage |

The original trial identifiers and randomized block assignments were preserved.

All 48 completed trials were retained for statistical analysis.

---

## 6. Statistical Methods

Statistical analyses were conducted using R.

The randomized complete block design was incorporated into the analyses to account for variation between blocks.

### 6.1 Descriptive Statistics

The arithmetic mean and sample standard deviation of trial-level median MSPT were calculated for each experimental condition.

Each condition included eight observations.

Standard error was calculated as:

\[
SE = \frac{s}{\sqrt{n}}
\]

where \(s\) is the sample standard deviation and \(n\) is the number of observations.

### 6.2 Baseline Adjustment

Each randomized block included one baseline trial without test hoppers.

Baseline-adjusted MSPT was calculated by subtracting the corresponding block's baseline median MSPT from each hopper-check trial's median MSPT.

\[
MSPT_{\mathrm{adjusted}} =
MSPT_{\mathrm{condition}} -
MSPT_{\mathrm{baseline}}
\]

The baseline measurement was matched by randomized block.

This provided a measure of the difference in server-wide median MSPT relative to the baseline condition.

Because these values were calculated from trial-level medians, they do not directly represent hopper-specific CPU processing time.

### 6.3 Repeated-Measures ANOVA

A repeated-measures analysis of variance was performed across all six conditions, including the no-hopper baseline.

```r
data$Block <- factor(data$Block)

data$Condition <- factor(
  data$Condition
)

anova_model <- aov(
  MSPT ~ Condition + Error(Block / Condition),
  data = data
)

summary(anova_model)
```

This analysis assessed whether server performance differed among the experimental conditions.

### 6.4 Friedman Tests

Friedman tests were used as nonparametric alternatives appropriate for the randomized block structure.

The first test included all six conditions:

```r
friedman.test(
  MSPT ~ Condition | Block,
  data = data
)
```

A second test included only the five hopper-check settings, excluding the no-hopper baseline:

```r
hopper_only <- subset(
  data,
  Hopper_Check != 0
)

friedman.test(
  MSPT ~ Hopper_Check | Block,
  data = hopper_only
)
```

The hopper-check-only test produced:

**χ²(4) = 18.6, p = 0.0009417**

This indicated statistically significant differences among the hopper-check settings overall.

The test does not identify which individual settings differ.

### 6.5 Paired Comparisons

Paired t-tests were conducted between consecutive hopper-check settings.

The comparisons were:

- HC 1 versus HC 2
- HC 2 versus HC 4
- HC 4 versus HC 8
- HC 8 versus HC 16

Observations were paired according to their randomized block.

To account for multiple comparisons, p-values were adjusted using the Holm method:

```r
p.adjust(
  results$P_Value,
  method = "holm"
)
```

An adjusted significance threshold of 0.05 was used.

None of the four adjacent comparisons remained statistically significant after Holm correction.

These results were not interpreted as proof of equivalence between settings.

### 6.6 Graphical Analysis

Graphs were created in R using `ggplot2`.

The visualizations included:

- Baseline-adjusted MSPT and diminishing returns
- Median versus 95th-percentile MSPT
- Reported CPU process usage
- Maximum tick-time measurements

The diminishing-returns graph included individual trial measurements, condition means, and 95% confidence intervals calculated using the Student's t-distribution.

These confidence intervals describe uncertainty around individual condition means, not the uncertainty of every pairwise comparison.

---

## 7. Experimental Controls

Several procedural controls were used to minimize unwanted variation.

| Controlled Factor | Procedure |
|---|---|
| Test World | Same Redstone Ready superflat world |
| Hopper Population | 10,000 for non-baseline trials |
| Hopper Orientation | All facing downward |
| Inventory Contents | All hoppers empty |
| Item Transportation | No items transferred |
| Surroundings | Air above and around hopper array |
| Hopper Height | Two blocks above the floor |
| Hopper-Transfer | Maintained at 8 |
| Player Count | One experimenter; no other players |
| Player Position | Flying above the center of the array |
| Player Direction | Facing south |
| Player Movement | Stationary during measurements |
| Server Restarts | Performed before each trial |
| Stabilization | Approximately 30 seconds after login |
| Profiling Duration | Approximately 60 seconds |
| Test Order | Randomized within eight blocks |

These controls were intended to make comparisons among hopper-check settings as consistent as possible.

They do not eliminate all sources of server performance variability.

---

## 8. Limitations and Sources of Uncertainty

### 8.1 Measurement Timing

Spark profiling was started and stopped manually using a separate 60-second timer.

Small deviations from exactly 60 seconds may have occurred.

Additionally, the observation windows for Spark's reported MSPT and CPU summary statistics have not been independently verified as matching the profiling period.

### 8.2 Server Startup Activity

Each trial included a server restart and approximately 30 seconds of stabilization after joining.

Background processes associated with startup, world loading, or garbage collection may still have influenced some measurements.

### 8.3 Server-Wide Measurements

MSPT and CPU usage represent server-wide performance measurements.

They do not directly isolate the processing cost of hopper-related functions.

### 8.4 Idle Hopper Workload

All 10,000 hoppers were empty and had only air above and around them.

No active item transportation occurred.

Therefore, the experiment does not directly characterize the performance of active hopper-based storage systems or farms.

### 8.5 Sample Size

Each experimental condition was measured eight times.

This provided repeated observations but limited the precision available for estimating small performance differences between higher hopper-check settings.

### 8.6 Maximum MSPT Spikes

Some trials recorded unusually large maximum MSPT values exceeding 1,000 milliseconds.

These observations were retained, but the causes of the spikes were not independently investigated.

### 8.7 Generalizability

Only one server environment and one hopper arrangement were tested.

The results may differ with other server hardware, Paper versions, plugin configurations, hopper arrangements, inventory states, or player activity.

---

## 9. Reproducibility

The repository preserves the available measurements, analysis scripts, and graphical outputs associated with this experiment.

The randomized trial sequence can be regenerated using the documented R code and random seed.

The CSV datasets permit independent recalculation of descriptive statistics and statistical tests.

Available Spark profiles may provide supplementary evidence for investigating server processing behavior.

A replication should reproduce the hopper arrangement, randomized block design, server restart procedure, player position, measurement timing, and analytical methods as closely as possible.

Future studies should additionally document the exact server build, processor hardware, allocated memory, Java version, and Spark version.

---

*Experimental methodology for the Minecraft Hopper Performance Research project.*
