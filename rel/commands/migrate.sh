#!/bin/sh

release_ctl eval --mfa "Planet.ReleaseTasks.migrate/1" -- "$@"
