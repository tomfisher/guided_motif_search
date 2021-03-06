## Guided motif search
Hoang Anh Dau

Oct 5th, 2017

**A working example:**

```
% load a dataset from folder named 'data'
>> data = load('data/finger_flexion_subLen_3500.mat');

% get the data vector from 'data' Matlab struct
>> data = data.data;

% specify subsequence length
>> subsequenceLength = 3500;

% creates an annotation vector that suppresses simplicity bias
>> [annotationVector] = make_AV_complexity(data, subsequenceLength);

% to see the (correct) top motif discovered by guided motif search
>> interactiveMatrixProfile(data, subsequenceLength, annotationVector);

% to see (possibly wrong) top motif discovered by classic matrix profile method
>> interactiveMatrixProfile(data, subsequenceLength);
```

### Function details

- interactiveMatrixProfile.m: This function has an optional input parameter, the annotation vector. Without the annotation vector, this function provides classic motif search. With the annotation vector, it is guided motif search.

```
% classic motif search
>> [matrixProfile, profileIndex, motifIndex, discordIndex] = interactiveMatrixProfile(data, subsequenceLength);

% guided motif search
>> [corrected_matrixProfile, profileIndex, motifIndex, discordIndex] = interactiveMatrixProfile(data, subsequenceLength, annotationVector);
```

- make_AV_complexity.m: creates an annotation vector that favors complexity

```
>> [annotationVector] = make_AV_complexity(data, subsequenceLength);
```

- make_AV_zerocrossing.m: creates an annotation vector that favors the number of zerocrossings

```
>> [annotationVector] = make_AV_zerocrossing(data, subsequenceLength);
```

- make_AV_stop_word.m: creates an annotation vector that suppress stop-word motifs (dataset-specific)

```
>> [annotationVector] = make_AV_stop_word(data, subsequenceLength);
```

- make_AV_suppressing_motion_artifact.m: creates an annotation vector that suppresses motion artifacts (dataset-specific)

```
>> [annotationVector] = make_AV_suppressing_motion_artifact(data, subsequenceLength);
```

- make_AV_suppressing_hard_limited_artifact.m: creates an annotation vector that suppresses hard-limited artifacts (dataset-specific)

```
>> [annotationVector] = make_AV_suppressing_hard_limited_artifact(data, subsequenceLength);
```

- correct_MP.m: computes the corrected matrix profile from the original matrix profile and the annotation vector

```
>> [MP_corrected] = correct_MP(matrixProfile, annotationVector);
```

- Time_series_Self_Join_Fast.m: computes the self-similarity join of a given time series (the GUI version of this is interactiveMatrixProfile.m). This function implements the original MASS method with time complexity O(n^2 log n).

```
>> [matrixProfile, matrixProfileIndex] = Time_series_Self_Join_Fast(data, subsequenceLength);
```

- test_AV_complexity.m: tests the accuracy of guided motif search method using AV_complexity on the MALLAT dataset.

```
>> [accuracy] = test_AV_complexity(data, motif_location, subsequenceLength);
```

- test_AV_zerocrossing.m: tests the accuracy of guided motif search method using AV_zerocrossing on MALLAT dataset.

```
>> [accuracy] = test_AV_zerocrossing(data, motif_location, subsequenceLength);
```

- [accuracy] = test_classic_MP.m: tests the accuracy of classic matrix profile method on MALLAT dataset

```
>> [accuracy] = test_classic_MP(data, motif_location, subsequenceLength);
```

- test_seizure: test the performance of classic motif search and guided motif search on the epilepsy seizure dataset

```
>> [label_classic, label_corrected] = test_seizure(train_data, test_data)
```
