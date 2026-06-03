# 1. Core Domain Requirements
## 1.1 Multiple organizations
 *Each org has:*
   - users (9-digit state id number, name, email...)
   - roles (custom per org)
   - *access policies*
       - these are scoped permissions - not custom per org. 
	   - are one of these: 'dataset_editor', 'expirement_runner', 'admin', 'analitics_team'
	   - each user can have multiple roles
   - **Users can belong to multiple orgs**

## 1.2 Datasets (versioned, immutable history)
*A dataset:*
 - logically identified by `dataset_key`
 - has many versions
 - has actual data - that has a custom shape (different per data set *)
 - *each version contains:*
   - description
   - version id
   - lineage reference (**optional** parent version)
   - an indication to the actual schema of the version's data (what is this version's data shape?).
 - *each data point in the versioned dataset*
	- is **expected** to have the shape this version has.
	- this expectation is **enforced** upon insertion of new data points.

*Constraints:* data inside each version is **append only!**. No one can change past data in a dataset, only add new data


## 1.3 Experiments
*An experiment:*
 - belongs to an org
 - references at least one, but optionally more - dataset versions
 - has a parameter sets (structured JSON / typed fields)
 - has execution runs


## 1.4 Runs (execution layer)
*A run:*
 - belongs to an experiment version
 - is executed on a compute cluster (which has an id, region, IP adress, and infra data like CPU cores, RAM in GBs, Disk dpace in TBs, Network Bandwidth in MBps)
 - has status lifecycle (queued → running → succeeded/failed/cancelled)
 - has logs (*append-only!* database enforces this)
 - has output artifacts (each run has its own output artifact, which is a structured report of its execution. But it has one of a few known pre-defined shapes)

Runs are retriable and replayable, but must preserve historical execution identity. execution history cannot be altered. 


## 1.5 Reproducibility
*You must track (views):*
 - which dataset versions were used in any expirement
 - which experiment version triggered a run, and the runtime environment analitics there

*You must support (functions):*
 - org-level roles (admin, researcher, viewer) by org id
 - which dataset versions were used in any expirement, by expirement id


## 1.6 Audit Log (append-only, tamper-evident design idea)
Every change to:
 - datasets
 - experiments
 - runs
 - permissions

**must be logged!** (triggers)

## 1.7 Advanced analytics (TOUGH excersizes):
  - a view where the columns are **ALL** the **version ids** of datasets, and under each column we have a single row, that is an array of all of these versions' parents (also their parents' parents, and grandparents... etc, recursively). The array **does not** HAVE to be sorted in any special way, but if you can sort it its nice.
  - a view where the columns are the ALL the **dataset ids** of all datasets, and the rows under each id are all the version ids that dataset has (or the string "-" where null is expected)


# 2. Hard Constraints (important)
 - No “flat” schema allowed (you must normalize meaningfully)
 - you must explicitly justify ALL design choices, and demonstrate tradeoff understanding (if any tradeoffs or caveats exist)