---
title: "Angular4 Best Practice Part 1"
date: 2018-04-10T12:24:17+03:00
draft: false
---

I will explain the best practices for Angular in nowadays. We will also introduce angular packages which are store, effects, router-store, store-devtools, entity, schematics.

# @ngrx/schematics
It provides blueprints for generating files when building out feature areas using NgRx like
Action, 
Container,
Effect,
Entity,
Feature,
Reducer and
Store.
 

At the beginning, create basic angular app with the following orders
```javascript
# First, create an angular app
ng new ngrx-best-practices-2018
cd ngrx-store-playground

// Install the schematics
yarn add @ngrx/schematics --dev

// Install the NgRx dependencies.
yarn add @ngrx/{store,effects,entity,store-devtools}
```

# @ngrx/store
It's a store management library for ngrx but first, we have to get the idea behind on it.

## What are these states? 
States come from state pattern.

There are three subjects we should know about this.

First is store, giant object or final data of our application.

Second is state, particularly action/status of the application. For example, the car on tier 2 means; The car's state for the tier is on two. In other words, the application tier is 2 (Application=Car). The car's state for the window is open/true.

Third are reducers, bunch of functions/methods help to change the states on the store.

Let's explain with some hack.

```javascript
// It's a super basic store
const data = { tier: 1, window: false };

// Reducers 
const increseTier = (data) => data = {
 ...data,
 tier: ++data.tier
} // Object spread

const toggleWindow = (data) => data = {
 ...data,
 window: !data.window
} // Object spread

//State changes
data = increseTier(data); // { tier: 2, window: false }

//State changes
data = toggleWindow(data); // { tier: 1, window: true }

```
Let's change this approach to little bit more handy

```javascript
// It's a super basic store
const data = { tier: 1, window: false };

// Reducers 
const reducers = (data, type) => {
  
  const increseTier = (data) => data = {
   ...data,
   tier: ++data.tier
  } // Object spread

  const toggleWindow = (data) => data = {
   ...data,
   window: !data.window
  } // Object spread

  switch(type) { 
    case 'increseTier':
     return increseTier(data);
    case 'toggleWindow':
     return toggleWindow(data);
  }

  return data;
}

// State changes
reducers(data, 'increseTier'); // { tier: 2, window: false }

// State changes
reducers(data,'toggleWindow'); // { tier: 1, window: true }


```
Calling reducers with the required parameters which are data(data=store) and action type('increaseTier') occur to alteration on the store. As such, the origin of mutation starts and depends on just two variable. 

## Simple ngrx/store usage

```sh
# Add ngrx store library
yarn add @ngrx/store
``` 

Every module has own store
```sh
# Generate store for app-module
ng generate store State --store --module app.module.ts --collection @ngrx/schematics
```

Schematics are allow to create state module files. Along with, injects required lines into the app.module

```javascript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { StoreModule } from '@ngrx/store';
import { reducers, metaReducers } from './reducers';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { environment } from '../environments/environment';


@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    // Here   <-------
    StoreModule.forRoot(reducers),
    !environment.production ? StoreDevtoolsModule.instrument() : []
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

```

Open reducers/index.ts which we generated. 

```javascript
import {
  ActionReducer,
  ActionReducerMap,
  createFeatureSelector,
  createSelector,
  MetaReducer
} from '@ngrx/store';
import { environment } from '../../environments/environment';

export interface State {

}

export const reducers: ActionReducerMap<State> = {

};


export const metaReducers: MetaReducer<State>[] = !environment.production ? [] : [];
```

We will implement the state pattern which we created on the upper section but in a way of angular store. 
Starting over reducers, ActionReducerMap and MetaReducer are two variables. Along with to make a mutation for store.

## Define a count into the State interface
```javascript
export interface State {
  count: number
}
```

Remember, on the upper section of car example, reducer usage was like this.
```javascript
// Past example

// Reducers 
const reducers = (data, type) => {
  
  const increseTier = (data) => data = {
   ...data,
   tier: ++data.tier
  } // Object spread
...
```

In conclusion, We will define function as like as increaseTier. Afterwards, We will add this function to reducer container like ActionReducerMap.

## Define a reducer for count
```javascript
function reducer (count = 0): number {
  return count;
}
```

## Define a ActionReducerMap
This is the basic state and whole store.
```javascript
export const reducers: ActionReducerMap<State> = {
  count: reducer
};
```

On calling state it returns.. 
```javascript
{
 count: function reducer(count = 0):number {
  return count
 }
}
// And It looks like this --->

{
 count: 0
}
```

## reducers/index.ts 

```javascript
import {
  ActionReducer,
  ActionReducerMap,
  createFeatureSelector,
  createSelector,
  MetaReducer
} from '@ngrx/store';
import { environment } from '../../environments/environment';

export interface State {
  count: number
}

function reducer (state = 0): number {
  return state;
}

export const reducers: ActionReducerMap<State> = {
  count: reducer
};

export const metaReducers: MetaReducer<State>[] = !environment.production ? [] : [];
```


## Observable
In the app-component file, we are using Observable to make a pipe callback and fetch the data by this callback from the store. Observable is works like a stream in any other additional languages. It is allowing us to chain more than one event instead of Promise chains. Observable also has the advantage over Promise to be cancelable.

## Selector
Use select operator to select slice(s) of state. It is a practical solution for the confusion of banana jungle problem. On the module, we update the current state. Afterwards, we have to find the related state in the whole store of every reducer. On conclude, using selectors prevent this repetition.


## app.component.ts

```javascript
import { Component } from '@angular/core';
import { Store, select, createSelector } from '@ngrx/store';
import { Observable } from 'rxjs';
import { State } from './reducers'

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent {
  title = 'app';
  //Variable as Observable
  count$: Observable<number>;
  
  constructor(private store: Store<State>) {
    // Selector
    this.count$ = store.pipe(select('count'));
  }
}
```

## app.component.html
We use async pipe for resolve promise or observable objects.

```html
<div>Current Count: {{ count$ | async }}</div>
```

Now we have store with initialState.

```sh
ng serve -o
```

![count0](/img/angular4-2018-best-practice-001.png)


In that part, we used shematics to built a tiny store. Next chapter, We are going to use other packages.
