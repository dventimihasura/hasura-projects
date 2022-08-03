-- -*- sql-product: postgres; -*-

-- Binary Classification

drop view if exists breast_cancer;

create or replace view breast_cancer as
  with eval as (
    select
      breast_cancer.*,
      pgml.predict(
	'Breast Cancer Detection', 
	ARRAY[
          "mean radius", 
          "mean texture", 
          "mean perimeter", 
          "mean area",
          "mean smoothness",
          "mean compactness",
          "mean concavity",
          "mean concave points",
          "mean symmetry",
          "mean fractal dimension",
          "radius error",
          "texture error",
          "perimeter error",
          "area error",
          "smoothness error",
          "compactness error",
          "concavity error",
          "concave points error",
          "symmetry error",
          "fractal dimension error",
          "worst radius",
          "worst texture",
          "worst perimeter",
          "worst area",
          "worst smoothness",
          "worst compactness",
          "worst concavity",
          "worst concave points",
          "worst symmetry",
          "worst fractal dimension"
	  ]
      ) AS prediction
      from pgml.breast_cancer)
  select
    eval.*,
    eval.malignant = (prediction>0.5) as correct
    from eval;

-- Regression

drop view if exists diabetes;

create or replace view diabetes as
  with eval as (
    select
      diabetes.*,
      pgml.predict('Diabetes Progression', ARRAY[age, sex, bmi, bp, s1, s2, s3, s4, s5, s6]) AS prediction
      from pgml.diabetes)
  select
    eval.*,
    eval.target = prediction
    from eval;

-- Image Classification

drop view if exists digits;

create or replace view digits as
  with eval as (
    select
      digits.*,
      pgml.predict('Handwritten Digits', image) AS prediction
      from pgml.digits)
  select
    eval.*,
    eval.target = prediction
    from eval;

-- Multi-class Classification

drop view if exists iris;

create or replace view iris as
  with eval as (
    select
      iris.*,
      pgml.predict('Iris Flower Types', ARRAY[sepal_length, sepal_width, petal_length, petal_width]) AS prediction
      from pgml.iris)
  select
    eval.*,
    eval.target = prediction
    from eval;

-- Joint Regression

drop view if exists linnerud;

create or replace view linnerud as
  with eval as (
    select
      linnerud.*,
      pgml.predict_joint('Exercise vs Physiology', ARRAY[chins, situps, jumps]) AS prediction
      from pgml.linnerud)
  select
    eval.*
    from eval;

drop table if exists pulse;

create table if not exists pulse (rate double precision);

create or replace function pulse_rate(chins real, situps real, jumps real)
  returns setof pulse
  stable
as $$
  select row((pgml.predict_joint('Exercise vs Physiology', ARRAY[chins, situps, jumps]))[3])
  $$ language sql
