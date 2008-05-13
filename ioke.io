#!/usr/bin/env io

Ioke := Object clone do (
	currentDesc := nil
	tasks := list()

	Task := Object clone do (
		append := method(name, desc, mesg, ctxt,
			task := Ioke Task clone
			task name := name asMutable replaceSeq("\"", "")
			task desc := desc
			task mesg := mesg
			task ctxt := ctxt
			Ioke tasks push(task)
			task
		)

		invoke := method(
			self ctxt doMessage(self mesg)
		)
	)

	showTasks := method(
		tasks foreach(task,
			task desc ifNil (continue)
			"#{System launchScript} #{task name alignLeft(24)} # #{task desc}" interpolate println
		)
	)

	invoke := method(name,
		tasks foreach (task,
			if (task name == name, task invoke)
		)
	)
)

desc := method(
	Ioke currentDesc = call message next name
	call message setNext(call message next)
)

task := method(
	name := call message next
	desc := Ioke currentDesc
	Ioke currentDesc = nil
	if (name) then (
		mesg := name argAt(0)
		ctxt := call message

		Ioke Task append(name name, desc, mesg, ctxt)
		call message setNext(name next)
	)
)

doFile("Iokefile")

desc "show tasks"
task "-T" (
	Ioke showTasks
)

if (System args size == 1) then (
	Ioke invoke("default")
) else (
	System args slice(1) foreach (name,
		Ioke invoke(name)
	)
)

# 括弧をなくしたことで見易くはなるが、DSL の旨みは少ない
# ( "show " .. num ) みたいなことができないため
# プログラマブルにするため括弧付きでも書けるようにすべきである

