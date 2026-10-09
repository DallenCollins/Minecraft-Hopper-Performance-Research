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
