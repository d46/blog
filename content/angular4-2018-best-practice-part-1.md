---
title: "Angular4 Best Practice Part 1"
date: 2018-04-10T12:24:17+03:00
draft: false
---

I'm going to explain, what are the best practices for Angular in nowadays. We will also introduce in angular packages that are store, effects, router-store, store-devtools, entity, schematics.

# @ngrx/schematics
It's a utility tool to generate 
Action, 
Container,
Effect,
Entity,
Feature,
Reducer and
Store

We will also explain and going to use all these subjects one by one..

```javascript
# First, create an angular app
ng new ngrx-best-practices-2018

// Install the schematics
yarn add @ngrx/schematics --dev

// Install the NgRx dependencies.
yarn add @ngrx/{store,effects,entity,store-devtools}
```

# @ngrx/store
It's a store management library for ngrx but first, we have to get the idea behind on it.

## What are these states? 
States come from state pattern.

There are three subjects we have to know about in this pattern.

First is a store. You can call it's a giant object or final data.

Second is a state. States are particularly actions/status in the flow. For example, the car on tier 2 is telling us; The car's state for the tier is on two. The car's state for the window is open/true.

Third are reducers. They are a bunch of functions/methods that help to change states in the store.

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
When the data and commands are send to reducer function the state changes as in order.

## Simple ngrx/store usage

```sh
# Add ngrx store library
cd ngrx-store-playground
yarn add @ngrx/store
``` 

Every module has own stores
```sh
# Generate store for app-module
ng generate store State --root --module app.module.ts --collection @ngrx/schematics
```

After that the store imports automatically by @ngrx/schematics into the app.module

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

Open reducers/index.ts that we generated before. 

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

Now we are going to implement the state pattern that we have already written before. There have been three subjects state, store, reducers. In reducers file ActionReducerMap and MetaReducer are two variables about for reducers. But we are going to use ActionReducerMap just for now.


## Define a count interface for state 
```javascript
export interface State {
  count: number
}
```

Remember, We were using reducer for car tier example like this

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

Reducer has been taken data and type as a parameter to change the state with functions as in order by type on the past example but for now we are putting on that to the next stage for modify the data by type


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

When reducer is called then it returns an object

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
In the app-component file, we are using Observable to pipe callbacks from the store. Observable is working like Streams in any other additional languages. It is allowing us to chain more than one event instead of Promise chains. Observable also has the advantage over Promise to be cancelable.



## app.component.ts
Use select operator to select slice(s) of state. In that case we have only count state.
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
  count$: Observable<number>;
  
  constructor(private store: Store<State>) {
    this.count$ = store.pipe(select('count'));
  }
}
```

## app.component.html
We are using async pipe for resolve promise or observable objects.

```html
<div>Current Count: {{ count$ | async }}</div>
```

Now we have a store with initialState.

```sh
ng serve -o
```

![count0](/img/angular4-2018-best-practice-001.png)


In that part ve used shematics and built a tiny store. Next chapter, We are going to use other packages.
